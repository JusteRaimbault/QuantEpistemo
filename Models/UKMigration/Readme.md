
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
  - collect 5 thread [Sun 19 Apr 2020 18:34:08 BST] killed Mon Apr 20 10:32:24 UTC 2020 ; relaunched 7 threads [Tue Apr 21 14:35:30 UTC 2020] ; killed on [Wed Apr 22 13:22:52 UTC 2020]
  - export full snapshot: 336487;644607;20201 ; export/corpus_full_20200422 
  - set hdepth for manual corpus db.references.updateOne({id:"17370031151598186972"},{$set:{horizontalDepth:{"laws_of_migration":NumberInt(1)}}}) ; db.references.updateOne({id:"14457835454175026919"},{$set:{horizontalDepth:{"theory_of_migration":NumberInt(1)}}}) ; db.references.updateOne({id:"8849441207113080135"},{$set:{horizontalDepth:{"costs_and_returns_human_migration":NumberInt(1)}}}) ; db.references.updateOne({id:"3467138637205862494"},{$set:{horizontalDepth:{"families_move":NumberInt(1)}}}) (! also int, as depth) ; reexport full (missing hdpeths) 
  - collect 10 threads [Thu Apr 23 14:14:05 UTC 2020] ; stopped [Fri Apr 24 12:44:43 UTC 2020] ; relaunch 7 [Sat Apr 25 22:23:28 UTC 2020] - killed [Apr 26, 2020 4:26:07 PM] null pointers: ? ; relaunch 7 [Mon Apr 27 20:42:16 UTC 2020] : but stop - pb selenium download ; relaunch 7 [Wed Apr 29 19:01:18 UTC 2020], killed [May 01, 2020 9:16:22] ; relaunch 6 [Mon May  4 20:49:24 UTC 2020] 

* export
 - [Thu Jul 23 10:25:51 UTC 2020] Full corpus: java -jar bibliodata.jar --database --export ukmigration export/corpus_full -1 -1 2 false "" -1
 - [Thu Jul 23 11:44:57 UTC 2020] Filtered: java -jar bibliodata.jar --database --export ukmigration export/corpus_filtered -1 -1 2 data/seedcorpus_exclude.csv "" -1
 - [Thu Jul 30 14:51:13 UTC 2020] Filtered non exclusive: Filtered: java -jar bibliodata.jar --database --export ukmigration export/corpus_filteredNonExcl -1 -1 2 data/seedcorpus_exclude.csv false "" -1

* mendeley data
 - [Thu Jul 23 20:19:36 UTC 2020] tests: author string incorrect for [467521895713926071,11100224317842467237,1960687713625528252,13069639178635581156,2840789860386075865,3843475204841863044,4974885501506490568,17662431745840099933,6836233999900169055,5352464221420183959] and [9405131435028266265] - (first test) ; and Keywords! ; launch for 100,000 (large test) - STOP stuck on a ref 61093635834171547: bug?
 - [Fri Jul 24 13:06:16 UTC 2020]: when no matching, need to update mendeleyChecked. Added source and type. (prev wont have)  ; fix ; Test ; add processing ; set numresp to 100 (a few ~5 ? did not match at 20 during test) ; launch collection 200000 Fri Jul 24 13:23:10 UTC 2020
 - [Thu Jul 30 08:59:45 UTC 2020] bug https connexion still allocated  => reset failed db.references.find({mendeleyChecked:"failed"}).count() : 1847 ; db.references.updateMany({mendeleyChecked:"failed"},{$set:{mendeleyChecked:"false"}}) : { "acknowledged" : true, "matchedCount" : 1847, "modifiedCount" : 1847 } ; fix by resetting client ; relaunch



