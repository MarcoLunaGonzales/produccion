<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
    Connection con=null;
    try
    {
        int codEstado=Integer.valueOf(request.getParameter("codEstadoProducto"));
        String consulta="select cod_presentacion,nombre_producto_presentacion"+
                        " from PRESENTACIONES_PRODUCTO"+
                        (codEstado>0?" where cod_estado_registro="+codEstado:"")+
                        " order by nombre_producto_presentacion asc";
        System.out.println(request.getParameter("codEstadoProducto")+"consulta cargar presentaciones "+consulta.toString());
        con=Util.openConnection(con);
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet res=st.executeQuery(consulta);
        out.println("<select id='codPresentacion' multiple='true' name='codPresentacion' class='inputText'>");
        while(res.next())
        {
            out.println("<option value=\" "+res.getString(1)+" \">"+res.getString(2)+"</option>");
        }
        out.println("</select>");
    }
    catch(Exception ex)
    {
        ex.printStackTrace();
    }
    finally
    {
        con.close();
    }
%>
