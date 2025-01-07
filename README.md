# ProjectLesiones

## Overview
`ProjectLesiones` is a SQL-based project designed to manage and analyze simulated data related to football injuries, treatments and specialists. The database provides insights into the types of injuries, treatments administered and the specialists involved in the treatment process.

## Features
- **Player Management**: Store and manage information about players, including their personal details and injury records.
- **Injury Tracking**: Record and track injuries, including their types, occurrence dates, and the treatments applied.
- **Treatment Management**: Store information about treatments and the specialists who administer them.
- **Specialist Management**: Manage details about specialists, including their specialties and the treatments they perform.
- **Query Capabilities**: Perform various queries to extract insights, such as the most common injuries, the most active specialists, and the treatments applied to specific injuries.

## Database Structure
The database consists of the following main tables:
- `jugador` (Player): Stores information about players.
- `lesion` (Injury): Stores information about different types of injuries.
- `tratamiento` (Treatment): Stores information about treatments.
- `especialista` (Specialist): Stores information about specialists.
- `jugador_lesion` (Player-Injury): Records the injuries suffered by players.
- `lesion_tratamiento` (Injury-Treatment): Records the treatments associated with each injury.
- `tratamiento_especialista` (Treatment-Specialist): Records the specialists associated with each treatment.
- `jugador_lesion_tratamiento_especialista` (Player-Injury-Treatment-Specialist): Records the treatments applied to players by specialists for specific injuries.

## Sample Queries
Here are some sample SQL queries to demonstrate the capabilities of `lesionesDB`:

1. **List players and the injuries they have suffered:**
   ```sql
   select j.nombre_jugador, l.nombre_lesion 
   from lesionesdb.jugador j 
   join lesionesdb.jugador_lesion jl 
	   on j.dni_jugador = jl.dni_jugador 
   join lesionesdb.lesion l 
	   on l.id_lesion = jl.id_lesion ;
   ```

2. **List treatments and the specialists who perform them:**
   ```sql
   select t.nombre_tratamiento, e.nombre_especialista 
   from lesionesdb.tratamiento t 
   join lesionesdb.tratamiento_especialista te 
	   on t.id_tratamiento = te.id_tratamiento 
   join lesionesdb.especialista e 
	   on e.dni_especialista = te.dni_especialista ;
   ```

3. **Find the most common injury and how many times it has occurred:**
   ```sql
   select l.nombre_lesion, count(jl.id_lesion) as frecuencia 
   from lesionesdb.lesion l 
   join lesionesdb.jugador_lesion jl 
	   on l.id_lesion = jl.id_lesion 
   group by l.id_lesion 
   order by frecuencia desc 
   limit 1 ;
   ```

4. **Obtain the specialists who have worked on at least 3 distinct treatments:**
   ```sql
   select e.nombre_especialista, count(distinct jlte.id_tratamiento) as distintos_tratamientos_efectuados 
   from lesionesdb.especialista e 
   join lesionesdb.jugador_lesion_tratamiento_especialista jlte 
	   on e.dni_especialista = jlte.dni_especialista
   group by jlte.dni_especialista 
   having count(distinct jlte.id_tratamiento) >= 3 ; 
   ```

## How to Use
1. **Setup**: Create the database and tables using the provided `LesionesDB` SQL script.
2. **Data Entry**: Populate the tables with relevant data for players, injuries, treatments, and specialists. The `LesionesDB` SQL script already includes some simulated data entries that can be utilized for educational purposes.
3. **Query**: Use the sample queries provided in `ExploratoryQueries` SQL script or write your own queries to extract insights and analyze the data.
