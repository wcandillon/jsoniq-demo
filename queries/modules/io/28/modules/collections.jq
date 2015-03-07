module namespace c = "http://28.io/modules/collections";

import module namespace credentials = "http://www.28msec.com/modules/credentials";

import module namespace mongo = "http://www.28msec.com/modules/mongodb";
import module namespace jdbc = "http://www.28msec.com/modules/jdbc";

declare variable $c:COLLECTION_NOT_FOUND := QName("c:COLLECTION_NOT_FOUND");

declare variable $c:sources :=
  for $cat in credentials:list-categories()()
  for $credentials in credentials:list-category-credentials($cat)()
  return $credentials
;

declare function c:collection($name as xs:string) as item()* {
  let $source := $c:sources[$$.name eq $name]
  return
    if($source.category eq "MongoDB") then
      mongo:find($source.con, $name)
    else if($source.category eq "MongoDB") then
      ()
    else
      error($c:COLLECTION_NOT_FOUND)
};
