﻿-- View: qgep.vw_network_node_small

-- DROP VIEW qgep.vw_network_node_small;

CREATE OR REPLACE VIEW qgep.vw_network_node_small AS 
 SELECT *
   FROM qgep.vw_network_node
  WHERE contains(geometryfromtext('POLYGON((749765 263730, 749765 263600, 749909 263600,749909 263730 , 749765 263730))'::text, 21781), vw_network_node.situation_geometry);
