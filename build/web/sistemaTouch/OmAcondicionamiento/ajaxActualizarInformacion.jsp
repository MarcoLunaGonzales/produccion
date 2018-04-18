<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%

Connection con=null;
Connection conOficial=null;
SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
try
{
    con=Util.openConnection(con);
    conOficial=DriverManager.getConnection("jdbc:sqlserver://172.16.10.21;user=sa;password=m0t1t4s@2009;databaseName=SARTORIUS");
    Statement st=conOficial.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    String consulta=" set dateformat ymd;SELECT COD_PROGRAMA_PROD,COD_COMPPROD,COD_FORMULA_MAESTRA,FECHA_INICIO,FECHA_FINAL,COD_ESTADO_PROGRAMA,"+
                    " COD_LOTE_PRODUCCION,VERSION_LOTE,CANT_LOTE_PRODUCCION,OBSERVACION,COD_TIPO_PROGRAMA_PROD,MATERIAL_TRANSITO,"+
                    " COD_PRESENTACION,COD_TIPO_APROBACION,NRO_LOTES,COD_COMPPROD_PADRE,cod_lugar_acond,COD_COMPPROD_VERSION,"+
                    " COD_FORMULA_MAESTRA_VERSION FROM PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD>220";
    String consultaInsert=" DELETE  FROM PROGRAMA_PRODUCCION where COD_PROGRAMA_PROD>220;";
    ResultSet res=st.executeQuery(consulta);
    while(res.next())
    {
        consultaInsert+="INSERT INTO dbo.PROGRAMA_PRODUCCION(COD_PROGRAMA_PROD, COD_COMPPROD,"+
                        " COD_FORMULA_MAESTRA,  COD_ESTADO_PROGRAMA,"+
                        " COD_LOTE_PRODUCCION, VERSION_LOTE, CANT_LOTE_PRODUCCION, OBSERVACION,"+
                        " COD_TIPO_PROGRAMA_PROD, MATERIAL_TRANSITO, COD_PRESENTACION, COD_TIPO_APROBACION"+
                        " , NRO_LOTES, COD_COMPPROD_PADRE, cod_lugar_acond, COD_COMPPROD_VERSION,"+
                        " COD_FORMULA_MAESTRA_VERSION)"+
                        " VALUES ("+res.getString("COD_PROGRAMA_PROD")+","+res.getInt("COD_COMPPROD")+
                        ","+res.getInt("COD_FORMULA_MAESTRA")+","+res.getInt("COD_ESTADO_PROGRAMA")+" " +
                        ",'"+res.getString("COD_LOTE_PRODUCCION")+"',"+(res.getInt("VERSION_LOTE"))+"," +
                        " '"+res.getInt("CANT_LOTE_PRODUCCION")+"','', '"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"'," +
                        " 0, 0,0, 0,0,0,'"+res.getInt("COD_COMPPROD_VERSION")+"','"+res.getInt("COD_FORMULA_MAESTRA_VERSION")+"');";
        
    }
    System.out.println("consulta insert "+consultaInsert);
    PreparedStatement pst=con.prepareStatement(consultaInsert);
    if(pst.executeUpdate()>0)System.out.println("se copiaron los lotes");
    consulta=" set dateformat ymd;SELECT COD_GESTION,COD_SALIDA_ALMACEN,COD_ORDEN_PESADA,COD_FORM_SALIDA,COD_PROD,COD_TIPO_SALIDA_ALMACEN,"+
             " COD_AREA_EMPRESA,NRO_SALIDA_ALMACEN,FECHA_SALIDA_ALMACEN,OBS_SALIDA_ALMACEN,ESTADO_SISTEMA,COD_ALMACEN,"+
             " COD_ORDEN_COMPRA,COD_PERSONAL,COD_ESTADO_SALIDA_ALMACEN,COD_LOTE_PRODUCCION,COD_ESTADO_SALIDA_COSTO,cod_prod_ant,"+
             " orden_trabajo,COD_PRESENTACION,codigo_hermes,COD_PROD1,COD_PERSONAL_ANULA,FECHA_ANULACION,COD_ESTADO_TRANSACCION_SALIDA,"+
             " COD_MAQUINA,COD_AREA_INSTALACION FROM SALIDAS_ALMACEN where FECHA_SALIDA_ALMACEN>'2014/09/01 00:00';";
    res=st.executeQuery(consulta);
    consultaInsert="DELETE FROM SALIDAS_ALMACEN where FECHA_SALIDA_ALMACEN>'2014/09/01 00:00';";
    while(res.next())
    {
        consultaInsert+="INSERT INTO dbo.SALIDAS_ALMACEN(COD_GESTION, COD_SALIDA_ALMACEN,"+
                        " COD_ORDEN_PESADA, COD_FORM_SALIDA, COD_PROD, COD_TIPO_SALIDA_ALMACEN,"+
                        " COD_AREA_EMPRESA, NRO_SALIDA_ALMACEN, FECHA_SALIDA_ALMACEN, OBS_SALIDA_ALMACEN,"+
                        " ESTADO_SISTEMA, COD_ALMACEN, COD_ORDEN_COMPRA, COD_PERSONAL,"+
                        " COD_ESTADO_SALIDA_ALMACEN, COD_LOTE_PRODUCCION, COD_ESTADO_SALIDA_COSTO,"+
                        " cod_prod_ant, orden_trabajo, COD_PRESENTACION,  COD_PROD1,"+
                        " COD_PERSONAL_ANULA, COD_ESTADO_TRANSACCION_SALIDA, COD_MAQUINA,"+
                        " COD_AREA_INSTALACION)"+
                        " VALUES ('"+res.getInt("COD_GESTION")+"','"+res.getInt("COD_SALIDA_ALMACEN")+"'," +
                        " '"+res.getInt("COD_ORDEN_PESADA")+"','"+res.getInt("COD_FORM_SALIDA")+"','"+res.getInt("COD_PROD")+"',"+
                        " '"+res.getInt("COD_TIPO_SALIDA_ALMACEN")+"','"+res.getInt("COD_AREA_EMPRESA")+"'," +
                        " '"+res.getInt("NRO_SALIDA_ALMACEN")+"','"+sdf.format(res.getTimestamp("FECHA_SALIDA_ALMACEN"))+"',"+
                        " '','"+res.getInt("ESTADO_SISTEMA")+"','"+res.getInt("COD_ALMACEN")+"','"+res.getInt("COD_ORDEN_COMPRA")+"'," +
                        " '"+res.getInt("COD_PERSONAL")+"','"+res.getInt("COD_ESTADO_SALIDA_ALMACEN")+"','"+res.getString("COD_LOTE_PRODUCCION")+"',"+
                        " '"+res.getInt("COD_ESTADO_SALIDA_COSTO")+"','"+res.getInt("cod_prod_ant")+"',"+
                        " '"+res.getString("orden_trabajo")+"','"+res.getInt("COD_PRESENTACION")+"'," +
                        " '"+res.getInt("COD_PROD1")+"', 0,"+
                        " '"+res.getInt("COD_ESTADO_TRANSACCION_SALIDA")+"','"+res.getInt("COD_MAQUINA")+"','"+res.getInt("COD_AREA_INSTALACION")+"');";
                           
    }
    System.out.println("consulta cargar salidas "+consultaInsert);
    pst=con.prepareStatement(consultaInsert);
    if(pst.executeUpdate()>0)System.out.println("se registro las salida");
    consulta="set dateformat ymd;SELECT COD_SALIDA_ALMACEN, COD_MATERIAL, CANTIDAD_SALIDA_ALMACEN, COD_UNIDAD_MEDIDA, COD_ESTADO_MATERIAL"+
             " FROM SALIDAS_ALMACEN_DETALLE where COD_SALIDA_ALMACEN in ( select sa.COD_SALIDA_ALMACEN from SALIDAS_ALMACEN sa where sa.FECHA_SALIDA_ALMACEN>'2014/09/01 00:00')";
    res=st.executeQuery(consulta);
    consultaInsert="set dateformat ymd; delete FROM  SALIDAS_ALMACEN_DETALLE where COD_SALIDA_ALMACEN in ( select sa.COD_SALIDA_ALMACEN from SALIDAS_ALMACEN sa where sa.FECHA_SALIDA_ALMACEN>'2014/09/01 00:00');";
    while(res.next())
    {
        consultaInsert+="INSERT INTO SALIDAS_ALMACEN_DETALLE(COD_SALIDA_ALMACEN, COD_MATERIAL,"+
                        " CANTIDAD_SALIDA_ALMACEN, COD_UNIDAD_MEDIDA, COD_ESTADO_MATERIAL)"+
                        " VALUES ('"+res.getInt("COD_SALIDA_ALMACEN")+"','"+res.getInt("COD_MATERIAL")+"'," +
                        " '"+res.getDouble("CANTIDAD_SALIDA_ALMACEN")+"',"+
                        " '"+res.getInt("COD_UNIDAD_MEDIDA")+"','"+res.getInt("COD_ESTADO_MATERIAL")+"');";
    }
    System.out.println("consulta insert detalle salidas "+consultaInsert);
    pst=con.prepareStatement(consultaInsert);
    if(pst.executeUpdate()>0)System.out.println("se registraron los detalle de las salida");
    consulta="set dateformat ymd; SELECT  COD_SALIDA_ALMACEN, COD_MATERIAL,COD_INGRESO_ALMACEN,ETIQUETA,COSTO_SALIDA,FECHA_VENCIMIENTO,"+
             " CANTIDAD,COSTO_SALIDA_ACTUALIZADO,FECHA_ACTUALIZACION,COSTO_SALIDA_ACTUALIZADO_FINAL,cod_hermes,TARA"+
             " FROM dbo.SALIDAS_ALMACEN_DETALLE_INGRESO where COD_SALIDA_ALMACEN in (select sa.COD_SALIDA_ALMACEN from SALIDAS_ALMACEN sa where sa.FECHA_SALIDA_ALMACEN>'2014/09/01 00:00');";
    res=st.executeQuery(consulta);
    consultaInsert="set dateformat ymd;delete FROM dbo.SALIDAS_ALMACEN_DETALLE_INGRESO where COD_SALIDA_ALMACEN in (select sa.COD_SALIDA_ALMACEN from SALIDAS_ALMACEN sa where sa.FECHA_SALIDA_ALMACEN>'2014/09/01 00:00');";
    while(res.next())
    {
        consultaInsert+="INSERT INTO dbo.SALIDAS_ALMACEN_DETALLE_INGRESO(COD_SALIDA_ALMACEN, COD_MATERIAL"+
                         " , COD_INGRESO_ALMACEN, ETIQUETA, COSTO_SALIDA,  CANTIDAD,"+
                        " COSTO_SALIDA_ACTUALIZADO,  COSTO_SALIDA_ACTUALIZADO_FINAL)"+
                        " VALUES ('"+res.getInt("COD_SALIDA_ALMACEN")+"','"+res.getInt("COD_MATERIAL")+"'," +
                        "'"+res.getInt("COD_INGRESO_ALMACEN")+"','"+res.getInt("ETIQUETA")+"',"+
                        "'"+res.getDouble("COSTO_SALIDA")+"','"+res.getDouble("CANTIDAD")+"'," +
                        " '"+res.getDouble("COSTO_SALIDA_ACTUALIZADO")+"','"+res.getDouble("COSTO_SALIDA_ACTUALIZADO_FINAL")+"');";
    }
    System.out.println("consulta insert detalle ingreso "+consultaInsert);
    pst=con.prepareStatement(consultaInsert);
    if(pst.executeUpdate()>0)System.out.println("se copiaron detalle ingresos");
    consultaInsert=" set dateformat ymd;delete SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL where COD_ACTIVIDAD_PROGRAMA in ("+
             " select a.COD_ACTIVIDAD_FORMULA from ACTIVIDADES_FORMULA_MAESTRA a where a.COD_ACTIVIDAD=29) and FECHA_INICIO>'2014/09/01 00:00';";
    consulta="select s.COD_PERSONAL,s.COD_PROGRAMA_PROD,s.COD_LOTE_PRODUCCION,s.COD_FORMULA_MAESTRA,"+
                    "s.COD_COMPPROD,s.COD_TIPO_PROGRAMA_PROD,s.COD_ACTIVIDAD_PROGRAMA,s.FECHA_REGISTRO,s.FECHA_INICIO,"+
                    " s.FECHA_FINAL,s.HORAS_HOMBRE from "+
                    " SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL s where s.COD_ACTIVIDAD_PROGRAMA in ("+
                    "select a.COD_ACTIVIDAD_FORMULA from ACTIVIDADES_FORMULA_MAESTRA a where a.COD_ACTIVIDAD=29) and s.FECHA_INICIO>'2014/09/01 00:00'";
    res=st.executeQuery(consulta);
    System.out.println("consulta tiempos "+consulta);
    while(res.next())
    {
        System.out.println(res.getString("COD_LOTE_PRODUCCION"));
        consultaInsert+="insert into SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL (COD_PERSONAL,COD_PROGRAMA_PROD,COD_LOTE_PRODUCCION,COD_FORMULA_MAESTRA,"+
                        "COD_COMPPROD,COD_TIPO_PROGRAMA_PROD,COD_ACTIVIDAD_PROGRAMA,FECHA_REGISTRO,FECHA_INICIO,"+
                        "FECHA_FINAL,HORAS_HOMBRE) values ('"+res.getInt("COD_PERSONAL")+"','"+res.getInt("COD_PROGRAMA_PROD")+"'," +
                        "'"+res.getString("COD_LOTE_PRODUCCION")+"','"+res.getInt("COD_FORMULA_MAESTRA")+"',"+
                        "'"+res.getInt("COD_COMPPROD")+"','"+res.getInt("COD_TIPO_PROGRAMA_PROD")+"'," +
                        "'"+res.getInt("COD_ACTIVIDAD_PROGRAMA")+"','"+sdf.format(res.getDate("FECHA_REGISTRO"))+"'," +
                        "'"+sdf.format(res.getTimestamp("FECHA_INICIO"))+"','"+sdf.format(res.getTimestamp("FECHA_FINAL"))+"'," +
                        "'"+res.getInt("HORAS_HOMBRE")+"');";
    }
    System.out.println("consulta insert "+consultaInsert);
    pst=con.prepareStatement(consultaInsert);
    if(pst.executeUpdate()>0)System.out.println("se registraron los tiempos de envasado");
    conOficial.close();
    out.clear();
    out.println("1");
}
catch(SQLException ex)
{
  
    ex.printStackTrace();
    out.clear();
    out.println("Ocurrio un error al cambiar el estado, intente de nuevo");
}
%>
