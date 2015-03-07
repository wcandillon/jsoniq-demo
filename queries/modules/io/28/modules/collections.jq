module namespace c = "http://28.io/modules/collections";

import module namespace credentials = "http://www.28msec.com/modules/credentials";

import module namespace mongo = "http://www.28msec.com/modules/mongodb";
import module namespace jdbc = "http://www.28msec.com/modules/jdbc";

declare variable $c:COLLECTION_NOT_FOUND := QName("c:COLLECTION_NOT_FOUND");

declare variable $c:sources :=
  for $cat in credentials:list-categories()()
  for $source in credentials:list-category-credentials($cat)()
  return {|
    $source,
    {
      con: if($source.category eq "MongoDB") then
        mongo:connect(credentials:credentials("MongoDB", $source.name))
      else if($source.category eq "JDBC") then
        jdbc:connect(credentials:credentials("JDBC", $source.name))
      else ()
    }
  |}
;

declare function c:collection($source as string, $name as string) as item()* {
  let $source := $c:sources[$$.name eq $source]
  return
    if($source.category eq "MongoDB") then
      mongo:find($source.con, $name)
    else if($source.category eq "JDBC") then
      jdbc:execute-query($source.con, "SELECT * FROM " || $name)
    else
      error($c:COLLECTION_NOT_FOUND)
};
