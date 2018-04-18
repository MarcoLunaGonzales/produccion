<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import="java.util.Locale" %>
<%@page import="java.text.DecimalFormatSymbols" %>
<%@ page import = "java.text.NumberFormat"%>
<%@page import="java.util.Date" %>

    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js"></script>
            <style>
                .eliminado
                {
                    background-color:#FFB6C1;
                }
                .modificado
                {
                    background-color:#F0E68C;
                }
                .especificacion
                {
                    background-color:#eec2ef;
                    font-weight:bold;
                }
                .nuevo
                {
                    background-color:#90EE90;
                }
                .tablaComparacion
                {
                    font-family:Verdana, Arial, Helvetica, sans-serif;
                    font-size:11px;
                    margin-top:1em;
                }
                .tablaComparacion tr td
                {
                    padding:0.4em;
                    border-bottom:1px solid #aaaaaa;
                    border-right:1px solid #cccccc;
                }
                .tablaComparacion thead tr td
                {
                    font-weight:bold;
                    background-color:#9d5a9e;
                    color:white;
                    text-align:center;
                }
            </style>
        </head>
        <body>
            <form>
                <center>
                   <%
                    String codEstadoVersion=request.getParameter("codEstadoVersion");
                    String codPersonal=request.getParameter("codPersonal");
                    String codVersion=request.getParameter("codVersion");
                    Connection con=null;
                    try
                    {
                        con=Util.openConnection(con);
                        con.setAutoCommit(false);
                        SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
                        StringBuilder consulta=new StringBuilder("INSERT INTO dbo.COMPONENTES_PROD_VERSION_MODIFICACION(COD_PERSONAL, COD_VERSION,");
                                      consulta.append(" COD_ESTADO_VERSION_COMPONENTES_PROD, FECHA_INCLUSION_VERSION)");
                                      consulta.append(" VALUES ('").append(codPersonal).append("','").append(codVersion).append("','").append(codEstadoVersion).append("','").append(sdf.format(new Date())).append("');");
                        System.out.println("consulta buscar version activa anterior "+consulta.toString());
                        PreparedStatement pst=con.prepareStatement(consulta.toString());
                        if(pst.executeUpdate()>0)System.out.println("se registro el personal");
                        consulta=new StringBuilder("SELECT count(*) as cantidadUsuariosFaltante FROM COMPONENTES_PROD_VERSION_MODIFICACION cpv where ");
                              consulta.append(" cpv.COD_VERSION='").append(codVersion).append("'  and cpv.COD_ESTADO_VERSION_COMPONENTES_PROD not in(3,7)");
                    System.out.println("consulta verificar usuarios pendientes de enviar a aproibac "+consulta.toString());
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet res=st.executeQuery(consulta.toString());
                    int cantidadUsuariosFaltantes=0;
                    if(res.next())cantidadUsuariosFaltantes=res.getInt("cantidadUsuariosFaltante");
                    consulta= new StringBuilder("select COUNT(*) as cantidadNoVersion from PERMISOS_VERSION_CP pv where pv.COD_PERSONAL not in ");
                             consulta.append(" (select c.COD_PERSONAL from COMPONENTES_PROD_VERSION_MODIFICACION c where c.COD_VERSION='").append(codVersion).append("')");
                             consulta.append(" and pv.PERSONAL_INVOLUCRADO_VERSION=1");
                    System.out.println("consulta verificar todos los usuarios presentes "+consulta);
                    res=st.executeQuery(consulta.toString());
                    if(res.next())cantidadUsuariosFaltantes+=res.getInt("cantidadNoVersion");
                    consulta=new StringBuilder("update COMPONENTES_PROD_VERSION set COD_ESTADO_VERSION=").append(cantidadUsuariosFaltantes==0?3:5);
                             consulta.append(" where COD_VERSION='").append(codVersion).append("'");
                    System.out.println("consulta update version "+consulta);
                    pst=con.prepareStatement(consulta.toString());
                    if(pst.executeUpdate()>0)System.out.println("se cambio el estado de la version");
                    con.commit();
                    out.println("<script>alert('Se registro la transacción');window.close()</script>");
                    }
                    catch(SQLException ex)
                    {
                        con.rollback();
                        out.println("<script>alert('ya se encontraba registrado(a) en la versión');window.close();</script>");
                        ex.printStackTrace();
                    }
                    finally
                    {
                        con.close();
                    }
                    %>
                    
                 </center>
            </form>
        </body>
    </html>
    
