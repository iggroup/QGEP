﻿CREATE OR REPLACE VIEW qgep.vw_special_structure AS

SELECT
  SS.obj_id
, SS.bypass
, SS.depth
, SS.emergency_spillway
, SS.function
, SS.stormwater_tank_arrangement
, SS.upper_elevation

, WS.accessibility
, WS.contract_section
, WS.detail_geometry_geometry
, WS.detail_geometry_3d_geometry
, WS.financing, gross_costs
, WS.identifier
, WS.inspection_interval
, WS.location_name
, WS.records
, WS.remark
, WS.renovation_necessity
, WS.replacement_value
, WS.rv_base_year
, WS.rv_construction_type
, WS.status
, WS.structure_condition
, WS.subsidies
, WS.year_of_construction
, WS.year_of_replacement
, WS.last_modification
, WS.dataowner
, WS.provider
, WS.fk_owner
, WS.fk_operator
  FROM qgep.od_special_structure SS
LEFT JOIN qgep.od_wastewater_structure WS
  ON WS.obj_id = SS.obj_id;

-------------------------------------------------------
-- DISCHARGE POINT INSERT
-- Function: vw_special_structure_insert()
-------------------------------------------------------

CREATE OR REPLACE FUNCTION qgep.vw_special_structure_insert()
  RETURNS trigger AS
$BODY$
BEGIN
  INSERT INTO qgep.od_wastewater_structure (
            obj_id
            , accessibility
            , contract_section
            , detail_geometry_geometry
            , detail_geometry_3d_geometry
            , financing
            , gross_costs
            , identifier
            , inspection_interval
            , location_name
            , records
            , remark
            , renovation_necessity
            , replacement_value
            , rv_base_year
            , rv_construction_type
            , status
            , structure_condition
            , subsidies
            , year_of_construction
            , year_of_replacement
            , last_modification
            , dataowner
            , provider
            , fk_owner
            , fk_operator )
    VALUES ( qgep.generate_oid('od_special_structure') -- obj_id
            , NEW.accessibility
            , NEW.contract_section
            , NEW.detail_geometry_geometry
            , NEW.detail_geometry_3d_geometry
            , NEW.financing
            , NEW.gross_costs
            , NEW.identifier
            , NEW.inspection_interval
            , NEW.location_name
            , NEW.records
            , NEW.remark
            , NEW.renovation_necessity
            , NEW.replacement_value
            , NEW.rv_base_year
            , NEW.rv_construction_type
            , NEW.status
            , NEW.structure_condition
            , NEW.subsidies
            , NEW.year_of_construction
            , NEW.year_of_replacement
            , NEW.last_modification
            , NEW.dataowner
            , NEW.provider
            , NEW.fk_owner
            , NEW.fk_operator
           )
           RETURNING obj_id INTO NEW.obj_id;

  INSERT INTO qgep.od_special_structure(
            obj_id, 
            bypass, 
            depth, 
            emergency_spillway, 
            function, 
            stormwater_tank_arrangement, 
            upper_elevation)
    VALUES (
            NEW.obj_id, 
            NEW.bypass, 
            NEW.depth, 
            NEW.emergency_spillway, 
            NEW.function, 
            NEW.stormwater_tank_arrangement, 
            NEW.upper_elevation);

  RETURN NEW;
END; $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION qgep.vw_special_structure_insert()
  OWNER TO qgep;

DROP TRIGGER IF EXISTS vw_special_structure_ON_INSERT ON qgep.vw_special_structure;

CREATE TRIGGER vw_special_structure_ON_INSERT INSTEAD OF INSERT ON qgep.vw_special_structure
  FOR EACH ROW EXECUTE PROCEDURE qgep.vw_special_structure_insert();

-------------------------------------------------------
-- DISCHARGE POINT UPDATE
-- Rule: vw_special_structure_ON_UPDATE()
-------------------------------------------------------

CREATE OR REPLACE RULE vw_special_structure_ON_UPDATE AS ON UPDATE TO qgep.vw_special_structure DO INSTEAD (
UPDATE qgep.od_special_structure
   SET bypass=NEW.bypass
     , depth=NEW.depth
     , emergency_spillway=NEW.emergency_spillway
     , function=NEW.function
     , stormwater_tank_arrangement=NEW.stormwater_tank_arrangement
     , upper_elevation=NEW.upper_elevation
  WHERE obj_id = OLD.obj_id;

  UPDATE qgep.od_wastewater_structure
  SET
    accessibility=NEW.accessibility
  , contract_section=NEW.contract_section
  , detail_geometry_geometry=NEW.detail_geometry_geometry
  , detail_geometry_3d_geometry=NEW.detail_geometry_3d_geometry
  , financing=NEW.financing
  , gross_costs=NEW.gross_costs
  , identifier=NEW.identifier
  , inspection_interval=NEW.inspection_interval
  , location_name=NEW.location_name
  , records=NEW.records
  , remark=NEW.remark
  , renovation_necessity=NEW.renovation_necessity
  , replacement_value=NEW.replacement_value
  , rv_base_year=NEW.rv_base_year
  , rv_construction_type=NEW.rv_construction_type
  , status=NEW.status
  , structure_condition=NEW.structure_condition
  , subsidies=NEW.subsidies
  , year_of_construction=NEW.year_of_construction
  , year_of_replacement=NEW.year_of_replacement
  , last_modification=NEW.last_modification
  , dataowner=NEW.dataowner
  , provider=NEW.provider
  , fk_owner=NEW.fk_owner
  , fk_operator=NEW.fk_operator
  WHERE obj_id = OLD.obj_id;
);

-------------------------------------------------------
-- DISCHARGE POINT DELETE
-- Rule: vw_special_structure_ON_DELETE()
-------------------------------------------------------

CREATE OR REPLACE RULE vw_special_structure_ON_DELETE AS ON DELETE TO qgep.vw_special_structure DO INSTEAD (
  DELETE FROM qgep.od_special_structure WHERE obj_id = OLD.obj_id;
  DELETE FROM qgep.od_wastewater_structure WHERE obj_id = OLD.obj_id;
);
