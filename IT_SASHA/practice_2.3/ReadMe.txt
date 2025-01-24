@startuml
entity "Mobilization_Reserves" as reserves {
    + reserve_id : INT <<PK>>
    --
    reserve_name : VARCHAR
    reserve_type : VARCHAR
    status : VARCHAR
    quantity : INT
    last_update_date : DATE
}

entity "Personnel" as personnel {
    + personnel_id : INT <<PK>>
    --
    name : VARCHAR
    role : VARCHAR
    reserve_id : INT <<FK>>
    status : VARCHAR
}

entity "Equipment" as equipment {
    + equipment_id : INT <<PK>>
    --
    equipment_type : VARCHAR
    status : VARCHAR
    reserve_id : INT <<FK>>
    last_service_date : DATE
}

' Зв'язки
reserves --{ personnel : "contains"
reserves --{ equipment : "contains"
@enduml