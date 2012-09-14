<?php
/**
 * Generic database object
 *
 * @author marian.borca
 */
abstract class DB_Object
{
    public $id = 0;
    public $type = NULL;
    
    static public function Get($id, $class=NULL, $ttl=NULL)
    {
        $class = is_null($class) ? strtolower(get_called_class()) : strtolower($class);
        return DB_Helper::ExecuteSingleObject("CALL {$class}_get ($id)", $class, $ttl);
    }
    static public function Select($class=NULL, $ttl=NULL)
    {
        $class = is_null($class) ? strtolower(get_called_class()) : strtolower($class);
        return DB_Helper::ExecuteObjectArray("CALL {$class}_select", $class, $ttl);
    }

    static public function ObjectFromArray($array, $class=NULL)
    {
        if(is_null($class)) $class = get_called_class();
        $object = new $class();
        foreach ($array as $key => $value)
            $object->$key = $value;
        if($object->id == 0)
            $object = NULL;
        return $object;
    }
    static public function ListFromArray($array, $class=NULL)
    {
        if(is_null($class)) $class = get_called_class();
        $list = array();
        foreach (array_values($array) as $val)
        {
            $object = new $class();
            foreach ($val as $key => $value)
                $object->$key = $value;
            if($object->id == 0)
                $object = NULL;
            $list[] = $object;
        }
        return $list;
    }
}

?>
