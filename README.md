# ProjectLesiones

## Overview
`ProjectLesiones` is a SQL-based project designed to manage and analyze data related to sports injuries, treatments, and specialists. The database provides insights into the types of injuries, treatments administered, and the specialists involved in the treatment process.

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
   SELECT j.nombre_jugador, l.nombre_lesion
   FROM jugador j
   JOIN jugador_lesion jl ON j.dni_jugador = jl.dni_jugador
   JOIN lesion l ON jl.id_lesion = l.id_lesion;
   ```

2. **List treatments and the specialists who perform them:**
   ```sql
   SELECT t.nombre_tratamiento, e.nombre_especialista
   FROM tratamiento t
   JOIN tratamiento_especialista te ON t.id_tratamiento = te.id_tratamiento
   JOIN especialista e ON te.dni_especialista = e.dni_especialista;
   ```

3. **Find the most common injury and how many times it has occurred:**
   ```sql
   SELECT l.nombre_lesion, COUNT(jl.id_lesion) AS frecuencia
   FROM lesion l
   JOIN jugador_lesion jl ON l.id_lesion = jl.id_lesion
   GROUP BY l.nombre_lesion
   ORDER BY frecuencia DESC
   LIMIT 1;
   ```

4. **Obtain the specialists who have worked on at least 3 distinct treatments:**
   ```sql
   SELECT e.dni_especialista, e.nombre_especialista, COUNT(DISTINCT te.id_tratamiento) AS tratamientos_distintos
   FROM especialista e
   JOIN tratamiento_especialista te ON e.dni_especialista = te.dni_especialista
   GROUP BY e.dni_especialista, e.nombre_especialista
   HAVING COUNT(DISTINCT te.id_tratamiento) >= 3;
   ```

## How to Use
1. **Setup**: Create the database and tables using the provided `LesionesDB` SQL script.
2. **Data Entry**: Populate the tables with relevant data for players, injuries, treatments, and specialists. In the same `LesionesDB` SQL script there are already some fake data entries that cna be used for educational purposes.
3. **Query**: Use the sample queries provided in `ExploratoryQueries` SQL script or write your own queries to extract insights and analyze the data.
