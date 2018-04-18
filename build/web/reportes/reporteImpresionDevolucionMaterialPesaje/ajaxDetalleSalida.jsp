<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>

<%
    Connection con=null;
    try
    {
            String codSalida=request.getParameter("codSalida");

            String consulta="select detalleIngreso.LOTE_MATERIAL_PROVEEDOR,m.COD_MATERIAL,m.NOMBRE_MATERIAL,sad.CANTIDAD_SALIDA_ALMACEN,"+
                            " um.ABREVIATURA"+
                            " from SALIDAS_ALMACEN_DETALLE sad inner join materiales m on m.COD_MATERIAL=sad.COD_MATERIAL"+
                            " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=sad.COD_UNIDAD_MEDIDA"+
                            " outer APPLY(select top 1 iade.LOTE_MATERIAL_PROVEEDOR from SALIDAS_ALMACEN_DETALLE_INGRESO sadi inner join INGRESOS_ALMACEN_DETALLE_ESTADO iade on"+
                            " sadi.COD_INGRESO_ALMACEN=iade.COD_INGRESO_ALMACEN and sadi.COD_MATERIAL=iade.COD_MATERIAL"+
                            " and sadi.ETIQUETA=iade.ETIQUETA"+
                            " where sadi.COD_SALIDA_ALMACEN=sad.COD_SALIDA_ALMACEN and sadi.COD_MATERIAL=sad.COD_MATERIAL"+
                            " ) detalleIngreso"+
                            " where sad.COD_SALIDA_ALMACEN='"+codSalida+"'"+
                            " order by m.NOMBRE_MATERIAL";
            System.out.println("consulta detalle "+consulta);

            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            ResultSet res=st.executeQuery(consulta);
            out.println("<table id='detalleSalidaMaterial' cellpadding='0' class='tablaSalidas'>");
            out.println("<thead><tr ><td rowspan='2'></td><td rowspan='2'>Material</td><td rowspan='2'>Lote<br/>Proveedor</td><td colspan='2'>Cantidad<br>Devolver</td><td rowspan='2'>Unidad<br>Medida</td></tr><tr><td>Tara</td><td>Neto</td></tr></thead><tbody>");
            while(res.next())
            {
                out.println("<tr>");
                out.println("<td><input type='checkbox' /></td>");
                out.println("<td>"+res.getString("NOMBRE_MATERIAL")+"<input type='hidden' value='"+res.getInt("COD_MATERIAL")+"'/></td>");
                out.println("<td><input type='text' class='inputText' value='"+res.getString("LOTE_MATERIAL_PROVEEDOR") +"'/></td>");
                out.println("<td><input type='text' class='inputText' onkeypress='valNum()' value=''/></td>");
                out.println("<td><input type='text' class='inputText' onkeypress='valNum()' value=''/></td>");
                out.println("<td>"+res.getString("ABREVIATURA")+"</td>");
                out.println("</tr>");
            }
            out.println("</tbody></table>");

    }
    catch(SQLException ex)
    {
        ex.printStackTrace();
    }
    finally
    {
        con.close();
    }
%>

    
