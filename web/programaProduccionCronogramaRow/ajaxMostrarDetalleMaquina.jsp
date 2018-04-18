

<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%
        String codMaquina= (request.getParameter("codMaquina")==null)||request.getParameter("codMaquina")==""?"0":request.getParameter("codMaquina");
        String fechaInicio=request.getParameter("fechaInicio");
        String fechaFinal=request.getParameter("fechaFinal");
        String[] fechaArray=fechaInicio.split("/");
        fechaInicio=fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0];
        fechaArray=fechaFinal.split("/");
        fechaFinal=fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0];
        String consulta = " select cp.nombre_prod_semiterminado,ppc.COD_LOTE_PRODUCCION,ppcd.FECHA_INICIO,ppcd.FECHA_FINAL"+
                          " from PROGRAMA_PRODUCCION_CRONOGRAMA ppc inner join PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd on"+
                          " ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA=ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA "+
                          " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=ppc.COD_COMPPROD  "+
                          " where ppcd.COD_MAQUINA='"+codMaquina+"' and ppcd.FECHA_INICIO BETWEEN '"+fechaInicio+" 00:00:00' and '"+fechaFinal+" 23:59:59'"+
                          " order by ppcd.FECHA_INICIO";
        System.out.println("consulta Detalle Maquina"+consulta);
        Connection con=null;
        con=Util.openConnection(con);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet res=st.executeQuery(consulta);
        out.println("<table id='detalleCronogramaMaquina' class='border'>");
        out.println(" <tr class='headerClassACliente'><td height='35px'>"+
                    "PRODUCTO</td><td>FECHA INICIO</td><td>FECHA FINAL</td></tr>");
        SimpleDateFormat sdf= new SimpleDateFormat("HH:mm");
        SimpleDateFormat sdt= new SimpleDateFormat("dd/MM/yyyy");
        while(res.next())
        {
            
            out.println("<tr class='outputText2'>");

            out.println("<td>"+res.getString("nombre_prod_semiterminado")+"</br>"+res.getString("COD_LOTE_PRODUCCION")+"</td>");
            out.println("<td><span>"+sdt.format(res.getTimestamp("FECHA_INICIO"))+"</span><input class='celda' value='"+sdf.format(res.getTimestamp("FECHA_INICIO"))+"'/></td><td><span>"+sdt.format(res.getTimestamp("FECHA_FINAL"))+"</span><input class='celda' value='"+sdf.format(res.getTimestamp("FECHA_FINAL"))+"'/></td>");
            out.println("</tr>");
        }
        out.println("</table>");
        res.close();
        st.close();
        con.close();
%>
