
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
    String fecha  = request.getParameter("fecha");
    System.out.println("parametro fecha " + fecha);
    String[] arrayFecha = fecha.split("/");
    String fecha1 = arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
    Gson gson = new Gson();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    Connection con = null;
    con = Util.openConnection(con);
    String consulta = " select m.COD_MAQUINA,cp.COD_COMPPROD,m.NOMBRE_MAQUINA,cp.nombre_prod_semiterminado ,pprc.COD_LOTE_PRODUCCION ,pprcd.FECHA_INICIO,pprcd.FECHA_FINAL" +
             " from" +
             " PROGRAMA_PRODUCCION_CRONOGRAMA pprc inner join " +
             " PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE pprcd on pprc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA = pprcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA" +
             " inner join maquinarias m on m.COD_MAQUINA = pprcd.COD_MAQUINA" +
             " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = pprc.COD_COMPPROD"+
             " where pprcd.FECHA_INICIO between '"+fecha1+" 00:00:00' and '"+fecha1+" 23:59:59'" +
             " or pprcd.FECHA_FINAL between '"+fecha1+" 00:00:00' and '"+fecha1+" 23:59:59'";
    System.out.println("consulta " + consulta);
    Statement st = con.createStatement();
    ResultSet rs = st.executeQuery(consulta);
    List lista = new ArrayList();
    while(rs.next()){
        CronogramaMaquinaria c = new CronogramaMaquinaria();
        //c.setId(rs.getString("cod_maquina"));
        c.setSection_id(rs.getString("cod_maquina"));
        c.setText(rs.getString("cod_lote_produccion") + " " +rs.getString("nombre_prod_semiterminado"));
        c.setStart_date(sdf.format(rs.getTimestamp("FECHA_INICIO")));
        c.setEnd_date(sdf.format(rs.getTimestamp("FECHA_FINAL")));
        //c.setColor("red");
        lista.add(c);
    }
    System.out.println("dato devuelto "+gson.toJson(lista));
    out.print(gson.toJson(lista));
    //CronogramaMaquinaria c = new CronogramaMaquinaria();
    
}catch(Exception e){e.printStackTrace();}
%>


