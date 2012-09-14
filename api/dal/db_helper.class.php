<?php
/**
 * Helper class for database queries
 *
 * @author marian.borca
 */
class DB_Helper
{
    static public function EscapeQuery($query)
    {
        // real_escape_string will encode quotes and string parameter values are changes
        // so we use a custom escape function
        return str_replace(';', '', $query);
    }

    static public function Connection()
    {
        $mysqli = new mysqli(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
        if (mysqli_connect_error())
            throw new Exception('Connect Error ('.mysqli_connect_errno().') '.mysqli_connect_error());
        return $mysqli;
    }
    static public function GetTtl($ttl=NULL)
    {
        // if TTL is NULL or TRUE, default cache TTL is used
        if(is_null($ttl) || $ttl === TRUE)
            return TV_CACHE_IN_SECONDS;
        // if TTL is not numeric or FALSE, no cache is used
        if(!is_numeric($ttl) || $ttl < 0)
            return FALSE;
        return $ttl;
    }
    
    static public function Execute($query, $query_type, $class=NULL, $ttl=NULL)
    {
        $ttl = self::GetTtl($ttl);
        $key = __METHOD__."_{$class}_$query"; // Cache key
        if($ttl !== FALSE && Cache::Exists($key) && !is_null(Cache::Fetch($key)))
            return Cache::Fetch($key);
        //
        $results = NULL;
        $mysqli = self::Connection();
        $query = self::EscapeQuery($query);
        if($query_type == QueryType::MultiReader)
        {
            if ($mysqli->multi_query($query))
            {
                do
                {
                    $result = $mysqli->use_result();
                    if ($result)
                    {
                        $records = array();
                        while ($row = $result->fetch_array()) $records[] = $row;
                        $result->close();
                        $results[] = $records;
                    }
                }
                while ($mysqli->next_result());
            }
        }
        else
        {
            $result = $mysqli->query($query);
            if(!$result)
                throw new Exception("ERROR ({$mysqli->errno}): {$mysqli->error}, QUERY: $query");
            switch ($query_type)
            {
                case QueryType::Reader:
                    while ($row = $result->fetch_assoc())
                        $results[] = $row;
                    break;
                case QueryType::Row:
                    $results = $result->fetch_assoc();
                    break;
                case QueryType::Scalar:
                    $row = $result->fetch_row();
                    $results = $row[0];
                    break;
                case QueryType::NonQuery;
                    $results = $result->num_rows;
                    break;
                case QueryType::SingleObject:
                    if(is_null($class))
                        throw new Exception("ERROR: Undefined class, cannot instantiate NULL class");
                    $results = $result->fetch_object($class);
                    if($results->id == 0)
                        $results = NULL;
                    break;
                case QueryType::ObjectArray:
                    if(is_null($class))
                        throw new Exception("ERROR: Undefined class, cannot instantiate NULL class");
                    while ($row = $result->fetch_object($class))
                    {
                        if($row->id == 0)
                            $row = NULL;
                        $results[] = $row;
                    }
                    break;
                default:
                    throw new Exception("ERROR: Undefined query type: $query_type");
            }
            $result->close();
        }
        $mysqli->close();
        if($ttl !== FALSE)
            Cache::Add($key, $results, $ttl);
        return $results;
    }

    static public function ExecuteSingleObject($query, $class, $ttl=NULL)
    {
        return self::Execute($query, QueryType::SingleObject, $class, $ttl);
    }
    static public function ExecuteObjectArray($query, $class, $ttl=NULL)
    {
        return self::Execute($query, QueryType::ObjectArray, $class, $ttl);
    }
    static public function ExecuteMultiReader($query, $ttl=NULL)
    {
        return self::Execute($query, QueryType::MultiReader, NULL, $ttl);
    }
    static public function ExecuteReader($query, $ttl=NULL)
    {
        return self::Execute($query, QueryType::Reader, NULL, $ttl);
    }
    static public function ExecuteRow($query, $ttl=NULL)
    {
        return self::Execute($query, QueryType::Row, NULL, $ttl);
    }
    static public function ExecuteScalar($query, $ttl=NULL)
    {
        return self::Execute($query, QueryType::Scalar, NULL, $ttl);
    }
    static public function ExecuteNonQuery($query, $ttl=NULL)
    {
        return self::Execute($query, QueryType::NonQuery, NULL, $ttl);
    }
}

?>
