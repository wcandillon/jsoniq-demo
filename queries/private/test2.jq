import module namespace jdbc = "http://www.28msec.com/modules/jdbc";

import module namespace credentials = "http://www.28msec.com/modules/credentials";

variable $users := jdbc:connect(credentials:credentials("JDBC", "users"));

jdbc:execute-query($users, "SELECT * FROM users")
