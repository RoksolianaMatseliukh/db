// 1) Знайти всіх дітей в яких сердня оцінка 4.2
db.getCollection('students').find({avgScore: 4.2})

// 2) Знайди всіх дітей з 1 класу
db.getCollection('students').find({class: 1})

// 3) Знайти всіх дітей які вивчають фізику
db.getCollection('students').find({lessons: "physics"})

// 4) Знайти всіх дітей, батьки яких працюють в науці ( scientist )
db.getCollection('students').find({"parents.profession": "scientist"})

// 5) Знайти дітей, в яких середня оцінка більша за 4
db.getCollection('students').find({avgScore: {$gt: 4}})

// 6) Знайти найкращого учня
db.getCollection('students').find({}).sort({avgScore: -1}).limit(1)

// 7) Знайти найгіршого учня
db.getCollection('students').find({}).sort({avgScore: 1}).limit(1)

// 8) Знайти топ 3 учнів
db.getCollection('students').find({}).sort({avgScore: -1}).limit(3)

// 9) Знайти середній бал по школі
db.getCollection('students').aggregate([
    {
        $group: {
            "_id": 0,
            "avgPoint": {
                $avg: "$avgScore"
                }
            }  
        },
        
    {
        $project: {
            "_id": 0
            }
        }
])

// 10) Знайти середній бал дітей які вивчають математику або фізику
db.getCollection('students').aggregate([
    {
       $match: {
           $or: [{lessons: "mathematics"}, {lessons: "physics"}]
           } 
        },

    {
        $group: {
            "_id": "Students_who_learn_mathematics_or_physics",
            "avgPoint": {
                $avg: "$avgScore"
                }
            }  
        }
])

// 11) Знайти середній бал по 2 класі
db.getCollection('students').aggregate([
    {
       $match: {class: 2} 
        },

    {
        $group: {
            "_id": "Students_in_second_class",
            "avgPoint": {
                $avg: "$avgScore"
                }
            }  
        }
])


// 12) Знайти дітей з не повною сімєю
    // якщо батьків взагалі нема або є лише хтось один з батьків:
    db.getCollection('students').find({"parents.1": {$exists: false}})

    // якщо є лише хтось один з батьків:
db.getCollection('students').find({parents: {$size: 1}})
    // або
db.getCollection('students').find(
    {$and:
        [ {"parents": {$exists: true}}, {"parents.1": {$exists: false}} ]
        }
)

// 13) Знайти батьків які не працюють
db.getCollection('students').find(
    {$and:
        [ {"parents": {$exists: true}}, {"parents.profession": {$eq: null}} ]
        }
)

        // або:
db.getCollection('students').find(
    {$and:
        [ {"parents": {$ne: null}}, {"parents.profession": null} ]
        }     
)       

// 14) Не працюючих батьків влаштувати офіціантами
db.getCollection('students').update(
    {
       $and:
        [ {parents: {$ne: null}}, {"parents.profession": null} ]
        },
        
    {
       $set: {"parents.$.profession": "waiter"}
        },
        
    {multi: true}       
)

// 15) Вигнати дітей, які мають середній бал менше ніж 2.5
db.getCollection('students').remove({avgScore: {$lt: 2.5}})

// 16) Дітям, батьки яких працюють в освіті ( teacher ) поставити 5
db.getCollection('students').update(
    {
        $and:
            [{parents: {$ne: null}}, {"parents.profession": "teacher"}]
        },
    {
        $set:
            {"avgScore" : 5}
        },
    {multi: true}
)

// 17) Знайти дітей які вчаться в початковій школі (до 5 класу) і вивчають фізику ( physics )
db.getCollection('students').find(
    {
       $and: [{class: {$lt: 5}}, {lessons: "physics"}] 
        }
)

// 18) Знайти найуспішніший клас
db.getCollection('students').aggregate([
    {$group: {
           "_id": "$class",           
            class: {$first: "$class"},
            avgScore: {$avg: "$avgScore"}  
        }},
    {$sort: {avgScore: -1}},
    {$project: {"_id": 0}},
    {$limit: 1}
])





// my: students from the best class
var bestClass = [];

db.getCollection('students').aggregate([
    {$group: {
           "_id": "$class",           
            class: {$first: "$class"},
            avgScore: {$avg: "$avgScore"}  
        }},
    {$sort: {avgScore: -1}},
    {$project: {"_id": 0}},
    {$limit: 1}
]).forEach((document) => { bestClass.push(document.class) })
//bestClass
db.getCollection('students').find({class: {$in: bestClass}})

    //or
var better = 0;

db.getCollection('students').aggregate([
    {$group: {
           "_id": "$class",           
            class: {$first: "$class"},
            avgScore: {$avg: "$avgScore"}  
        }},
    {$sort: {avgScore: -1}},
    {$project: {"_id": 0}},
    {$limit: 1}
]).forEach((document) => { better = document.class })
//better
db.getCollection('students').find({class: better})





db.getCollection('students').aggregate([
    {$group: {
           "_id": "$class",           
            class: {$first: "$class"},
            avgPoint: {$avg: "$avgScore"}  
        }},
    {$group: {
        "_id": 0,
        maxScore: {$max: "$avgPoint"}
        }}
])