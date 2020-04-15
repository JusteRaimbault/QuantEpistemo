PRIORITY=$1

mongo ukmigration --quiet --eval "db.references.find({\"citingFilled\":false,\"depth\":{\$gt:0},\"priority\":{\$lt:$PRIORITY}}).count()"

