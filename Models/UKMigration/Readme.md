
* initial kw request java -jar bibliodata.jar --keywords --mongo queries_formatted.csv ukmigration 100 2 true
  => 760 references
* incr depth 2 times => depth 2

* add manual corpus
  -  additional manual references java -jar bibliodata.jar --citation --mongo-ids ukmigration data/sanity_check_samples.csv true 
  => 4050 references, 3907 links
  -  remove unwanted empty ref (! no header in csv) db.references.findOneAndDelete({id:"id"})
  -  update manual ref titles (bug csv import?) db.references.findOneAndUpdate({id:"17370031151598186972"},{$set:{"title":"The laws of migration"}}) ; db.references.findOneAndUpdate({id:"14457835454175026919"},{$set:{"title":"A theory of migration"}}) ; db.references.findOneAndUpdate({id:"8849441207113080135"},{$set:{"title":"The costs and returns of human migration"}}) ; db.references.findOneAndUpdate({id:"3467138637205862494"},{$set:{"title":"Why families move"}})
  - set -1 depth to 1 manually (rq: manual corpus also at 1: update each at 2) db.references.updateMany({depth:-1},{$set:{depth:1}})
     { "acknowledged" : true, "matchedCount" : 3285, "modifiedCount" : 3285 }
  - trick priorities db.references.updateMany({depth:2},{$set:{priority:10}}); db.references.updateMany({depth:1},{$set:{priority:1}})
  - get citing for first manual layer java -jar bibliodata.jar --citation --mongo ukmigration 50 2 true 
    !!! bug (add stack trace in getUnfilled) : pb with non integer depth when update by hand ->  db.references.updateMany({depth:2},{$set:{depth:NumberInt(2)}})
     { "acknowledged" : true, "matchedCount" : 764, "modifiedCount" : 4 } ; db.references.updateMany({depth:1},{$set:{depth:NumberInt(1)}})
     { "acknowledged" : true, "matchedCount" : 3285, "modifiedCount" : 3285 }
  - export (first layer only) java -jar bibliodata.jar --database --export ukmigration export/corpus_withmanual_20200415 (set priorities to int first)
  - [Wed 15 Apr 2020 21:15:54 BST] collect second layer ./parrun.sh "java -jar bibliodata.jar --citation --mongo ukmigration 300 2 true" 10
  - [Thu Apr 16 10:07:56 UTC 2020] killed (also other single thread relaunched with 200)
  - [Thu Apr 16 14:11:37 UTC 2020]test single thread to see rate  java -jar bibliodata.jar --citation --mongo ukmigration 860 2 true !!! kill, all ips dead
  - [Fri 17 Apr 2020 14:42:43 BST] single thread 10 papers (test) ; rest: OK [Sun Apr 19 07:04:52 UTC 2020]
  - [Sun 19 Apr 2020 10:27:57 BST] 5 threads keywords: ./parrun.sh "java -jar bibliodata.jar --citation --mongo ukmigration 200 15 true" 5
  - [Sun Apr 19 16:59:07 UTC 2020] : layer 1 keywords finished ; 229373;400813;29786
  - set first layer priority : db.references.updateMany({depth:{$gt:0}},{$set:{priority:NumberInt(1)}})
     { "acknowledged" : true, "matchedCount" : 33835, "modifiedCount" : 30550 }
  - collect 5 thread [Sun 19 Apr 2020 18:34:08 BST] killed Mon Apr 20 10:32:24 UTC 2020 ; relaunched 7 threads [Tue Apr 21 14:35:30 UTC 2020]


