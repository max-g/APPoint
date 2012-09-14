<?php
/**
 * Enumerations definition
 *
 * @author marian.borca
 */
final class QueryType
{
    const Reader = 1;
    const MultiReader = 2;
    const Row = 3;
    const Scalar = 4;
    const NonQuery = 5;
    const SingleObject = 6;
    const ObjectArray = 7;
}
final class QueryMode
{
    const Query = 1;
    const StoredProcedure = 2;
}

?>
