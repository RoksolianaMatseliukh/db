# 1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
select * from client where length(FirstName) < 6;

# 2. +Вибрати львівські відділення банку.+
select * from department where DepartmentCity = 'Lviv';

# 3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
select * from client where Education = 'high'
                        order by LastName;

# 4. +Виконати сортування у зворотньому порядку над таблицею Заявка
# і вивести 5 останніх елементів.
select  * from application where idApplication > 10
                            order by idApplication desc;

# 5. +Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
#       у таблиці відсутні прізвища, які закінчуються на 'ov' або 'ova'
select * from client where LastName like '_e%' and LastName like  '%k';

# 6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.
select FirstName, LastName, DepartmentCity from client c
        join department d on c.Department_idDepartment = d.idDepartment
        where DepartmentCity = 'Kyiv';

#     or
select * from client
        where Department_idDepartment in (select idDepartment from department where DepartmentCity = 'Kyiv');

# 7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
#       у таблиці відсутні номери телефонів
select FirstName, Passport from client order by FirstName;

# 8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
select FirstName, LastName, Passport, City, Age, count(Sum) `credits number with sum > 5000`
        from client c
        join application a on c.idClient = a.Client_idClient
        where Sum > 5000
        group by FirstName, LastName, Passport, City, Age
        order by `credits number with sum > 5000` desc;

#     or
select * from client
        where idClient in (select Client_idClient from application where Sum > 5000);

#     якщо йдеться про суму кредитів
select FirstName, LastName, Education, Passport, City, Age, sum(Sum) credits_sum from client c
        join application a on c.idClient = a.Client_idClient
        group by FirstName, LastName, Education, Passport, City, Age
        having sum(Sum) > 5000
        order by sum(Sum);

# 9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
select (select count(idClient) from client c
        join department d on c.Department_idDepartment = d.idDepartment) clients_number_of_all_departments,
       (select count(idClient) from client c
        join department d on c.Department_idDepartment = d.idDepartment
        where DepartmentCity = 'Lviv') clients_number_of_Lviv_departments;

#     якщо по-окремо:
select count(idClient) clients_number_of_all_departments from client c
        join department d on c.Department_idDepartment = d.idDepartment;

#     or
select count(idClient) clients_number_of_all_departments, d.DepartmentCity
        from client c
        join department d on c.Department_idDepartment = d.idDepartment
        group by DepartmentCity;

select count(idClient) clients_number, d.DepartmentCity
        from client c
        join department d on c.Department_idDepartment = d.idDepartment
        where DepartmentCity = 'Lviv';

# 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
select FirstName name, max(Sum) max_credit from application a
        join client c on c.idClient = a.Client_idClient
        group by FirstName
        order by max_credit;

# 11. Визначити кількість заявок на крдеит для кожного клієнта.
select FirstName name, count(idClient) credits_number from application a
        join client c on c.idClient = a.Client_idClient
        group by FirstName
        order by credits_number;

# 12. Визначити найбільший та найменший кредити.
select max(Sum) max_credit, min(Sum) min_credit from application;

#     якщо найбільший та найменший кредит для кожного клієнта:
select FirstName name, max(Sum) max_credit, min(Sum) min_credit from application a
        join client c on c.idClient = a.Client_idClient
        group by FirstName;

# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
select FirstName name, Education, count(idClient) credits_number from client c
        join application a on c.idClient = a.Client_idClient
        where Education = 'high'
        group by name
        order by credits_number;

# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
select FirstName, LastName, Education, Passport, City, Age, avg(Sum) average_sum from client c
        join application a on c.idClient = a.Client_idClient
        group by FirstName, LastName, Education, Passport, City, Age
        order by avg(Sum) desc
        limit 1;

        # or

select FirstName, LastName, Education, Passport, City, Age, max(average_sum)
    from (
        select FirstName, LastName, Education, Passport, City, Age, avg(Sum) average_sum
            from client c
            join application a on c.idClient = a.Client_idClient
            group by FirstName, LastName, Education, Passport, City, Age
        ) selectTable
    group by FirstName, LastName, Education, Passport, City, Age
    order by max(average_sum) desc
    limit 1;


select max(avg_value)
        from
        (select avg(Sum) avg_value from application group by Client_idClient) tmp;

# 15. Вивести відділення, яке видало в кредити найбільше грошей
select idDepartment, DepartmentCity, CountOfWorkers, sum(Sum) credit_sum from department d
        join client c on d.idDepartment = c.Department_idDepartment
        join application a on c.idClient = a.Client_idClient
        group by idDepartment, DepartmentCity, CountOfWorkers
        order by credit_sum desc
        limit 1;

# 16. Вивести відділення, яке видало найбільший кредит.
select idDepartment, DepartmentCity, CountOfWorkers, max(Sum) credit from department d
        join client c on d.idDepartment = c.Department_idDepartment
        join application a on c.idClient = a.Client_idClient
        group by idDepartment, DepartmentCity, CountOfWorkers
        order by credit desc
        limit 1;

# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
update application set Sum = 6000
        where Client_idClient in (select idClient from client where Education = 'high');

# 18. Усіх клієнтів київських відділень пересилити до Києва.
update client set City = 'Kyiv'
        where Department_idDepartment in (select idDepartment from department where DepartmentCity = 'Kyiv');

# 19. Видалити усі кредити, які є повернені.
delete from application where CreditState = 'Returned';

# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
delete from application
        where Client_idClient in (select idClient from client where LastName like '_o%' or LastName like '_e%');

# Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
select idDepartment, DepartmentCity, CountOfWorkers, sum(Sum) credits_sum from department d
        join client c on d.idDepartment = c.Department_idDepartment
        join application a on c.idClient = a.Client_idClient
        where DepartmentCity = 'Lviv'
        group by idDepartment, DepartmentCity, CountOfWorkers
        having credits_sum > 5000
        order by credits_sum;

# Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
select FirstName, LastName, Passport, City, Age, CreditState, sum(Sum) returned_credits_sum from client c
        join application a on c.idClient = a.Client_idClient
        where CreditState = 'Returned'
        group by FirstName, LastName, Passport, City, Age, CreditState
        having returned_credits_sum > 5000;

/* Знайти максимальний неповернений кредит.*/
select  max(Sum) not_returned_max_credit from application
        where CreditState = 'Not Returned';

# select max(Sum) not_returned_max_credit from application a
#         join client c on c.idClient = a.Client_idClient
#         where Sum in (select sum(Sum) from application where CreditState = 'Returned') < Sum in
#                         (select Sum from application where CreditState = 'Not Returned');

/*Знайти клієнта, сума кредиту якого найменша*/
select FirstName, LastName, Passport, City, Age, Sum min_credit from  client c
        join application a on c.idClient = a.Client_idClient
        group by FirstName, LastName, Passport, City, Age, Sum
        order by Sum
        limit 1;

/*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/
select idApplication, Sum, CreditState, Currency from application
        where Sum > (select avg(Sum) from application)
        order by Sum;

/*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/
select * from client
        where City = (select City from client c
                        join application a on c.idClient = a.Client_idClient
                        group by FirstName, City
                        order by count(Sum) desc
                        limit 1);

#місто чувака який набрав найбільше кредитів
select City from client
        where City = (select City from client c
                        join application a on c.idClient = a.Client_idClient
                        group by FirstName, City
                        order by count(Sum) desc
                        limit 1);