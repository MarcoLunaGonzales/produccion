<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%
ServletOutputStream sout = response.getOutputStream();
Connection con=null;
try 
{
    response.setContentType("image/jpeg");
    response.setHeader("Content-Disposition", "inline; filename=imagen.jpg");
    response.setHeader("Cache-control", "public");
    int codPersonal=Integer.valueOf(request.getParameter("codPersonal"));

    try {
        con = Util.openConnection(con);
        StringBuilder consulta = new StringBuilder("select f.FIRMA");
                    consulta.append(" from FIRMAS_CERTIFICADO_CC f");
                    consulta.append(" where f.COD_PERSONAL=").append(codPersonal);
        Statement st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet res = st.executeQuery(consulta.toString());

        byte[] imagen=null;
        while (res.next()) {
            imagen=res.getBytes("FIRMA");
            sout.write(imagen);
        }
        sout.flush();



    } catch (SQLException ex) {
        ex.printStackTrace();
    } catch (Exception ex) {
        ex.printStackTrace();
    } 

}
finally
{
    sout.close();
    try
    {
        con.close();
    }catch(Exception ex){ex.printStackTrace();}
}
%>