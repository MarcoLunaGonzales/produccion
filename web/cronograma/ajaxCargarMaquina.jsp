
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%@page import="com.google.gson.Gson" %>
<%@page import="java.io.*" %>
<%@page import="com.cofar.json.*" %>
<%@page import="com.cofar.*" %>
<%@page import="com.cofar.bean.*" %>
<%@page import="java.util.List" %>
<%@page import="java.util.ArrayList" %>


<%
/*BufferedReader buffer=new BufferedReader(new InputStreamReader(request.getInputStream()));
        String content="";
        String jsonContent="";
        while(  (content=buffer.readLine())!=null )
            jsonContent+=content;
        System.out.println("jsonContent:"+jsonContent);
        Gson g=new Gson();
        RespuestaCuestionarioPersonalCargo cuestionarioPersonalCargo=g.fromJson(jsonContent,RespuestaCuestionarioPersonalCargo.class);
        Connection con=null;
try
{
System.out.println( cuestionarioPersonalCargo.getCodCuestionarioCargo());
}
catch(Exception ex)
{
    out.clear();
    out.println("Ocurrio un error en el registro,intente de nuevo");
    
    con.rollback();
    ex.printStackTrace();
}
finally
{
    con.close();
}*/
try{
    Gson gson = new Gson();
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy hh:mm:ss");
    Connection con = null;
    con = Util.openConnection(con);
    String consulta = " select distinct m.COD_MAQUINA,m.NOMBRE_MAQUINA" +
             " from" +
             " PROGRAMA_PRODUCCION_CRONOGRAMA pprc inner join " +
             " PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE pprcd on pprc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA = pprcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA" +
             " inner join maquinarias m on m.COD_MAQUINA = pprcd.COD_MAQUINA" +
             " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = pprc.COD_COMPPROD ";
    System.out.println("consulta " + consulta);
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery(consulta);
    List lista = new ArrayList();
    while(rs.next()){
        SeccionesMaquina s = new SeccionesMaquina();
        s.setKey(rs.getString("cod_maquina"));
        s.setLabel(rs.getString("nombre_maquina"));
        lista.add(s);
    }
    out.print(gson.toJson(lista));
    //CronogramaMaquinaria c = new CronogramaMaquinaria();
    
}catch(Exception e){e.printStackTrace();}
%>


