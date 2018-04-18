
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page  import="javazoom.upload.*,java.util.*,java.io.*" %>
<%@ page  import="jxl.*" %>
<%@ page  import="jxl.Sheet" %>
<%@ page  import="jxl.Workbook" %>
<%@ page import="java.text.*" %>
<%
   
    String direccion = request.getSession().getServletContext().getRealPath("componentesProdVersion/certificadosPdf/");
%>
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
    <jsp:setProperty name="upBean" property="folderstore" value="<%=direccion%>" />
    <jsp:setProperty name="upBean" property="whitelist" value="*.pdf" />
    <jsp:setProperty name="upBean" property="overwritepolicy" value="nametimestamp"/>
</jsp:useBean>

<%
    try
    {
    Connection con=null;
    con=Util.openConnection(con);
    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    ResultSet res=st.executeQuery(" select distinct c.DIRECCION_ARCHIVO_REGISTRO_SANITARIO,c.COD_VERSION"+
                                  " from COMPONENTES_PROD_VERSION c"+
                                  " where len(isnull(c.DIRECCION_ARCHIVO_REGISTRO_SANITARIO,''))>3");
    PreparedStatement pst=con.prepareStatement("update COMPONENTES_PROD_VERSION set CERTIFICADO_REGISTRO_SANITARIO=? where COD_VERSION=?");
    while(res.next())
    {
        String direccionAux=direccion+"/"+res.getString("DIRECCION_ARCHIVO_REGISTRO_SANITARIO");
        try
        {
        
        System.out.println("direccion "+direccionAux);
        RandomAccessFile f=new RandomAccessFile(direccionAux,"r");
        byte[] b = new byte[(int)f.length()];
        f.readFully(b);
        pst.setBytes(1,b);
        pst.setInt(2,res.getInt("COD_VERSION"));
        if(pst.executeUpdate()>0)System.out.println("se registro el documento");
        }
        catch(IOException io)
        {
            System.out.println("-------------------------------------------------------------ERROR--------------------------------------------------");
            System.out.println("direccion no encontrada"+direccionAux);
        }
    }
    System.out.println("termino");
    }
    catch(SQLException ex)
    {
        ex.printStackTrace();
    }
    out.println("termino");
%>