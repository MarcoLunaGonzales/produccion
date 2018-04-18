<%@page contentType="text/html"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
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
<html >
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <style>
            table{
                border-top:1px solid black;
                width:85%;
                border-left:1px solid black;
                margin-top:12px;
            }
            td{
                font-weight:normal;
                border-bottom:1px solid black;
                border-right:1px solid black;
                padding:5px;
                padding-top:6px;
                padding-bottom:6px;
            }
            .headerC{
                font-weight:bold;
                font-size:14px;
                color:white;
                background-color:#9d5a9e;
                padding:3px;
            }
        </style>
        <script>
            var contPopup=0;
               function verDocumento(codCuestionario,codPersonal){
                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    window.location.href='navegadorCuestionarioCargo.jsf?codPersonal='+codPersonal+'&codP='+Math.random()+'&codCuestionario='+codCuestionario;
                     
             }
           </script>
    </head>
    <body style="border:none;" ><br><br>
        <h3 align="center"></h3>
            
        <form name="upform" method="post" action="agregarDocumentacionBiblioteca.jsf" enctype="multipart/form-data">
            <div  id="formsuper"  style="
                padding: 50px;
                background-color: #cccccc;
                position:absolute;
                z-index: 1;
                left:0px;
                top: 0px;
                border :2px solid #3C8BDA;
                width :100%;
                height: 100%;
                filter: alpha(opacity=70);
                visibility:hidden;
                opacity: 0.8;" >
                    
          </div>
            <div align="center">
                            <h3 >Cuestionarios Personal</h3>
            <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td  align="center" colspan="" class="headerC outputText2" >Cuestionario</td>
                        <td  align="center" colspan="" class="headerC outputText2" >Tiempo Examen</td>
                        <td  align="center" colspan="" class="headerC outputText2" >Fecha evaluación</td>
                        <td  align="center" colspan="" class="headerC outputText2" >Examen</td>
                    </tr>
                    
                    <%
                    try
                    {
                        Connection con=null;
                        con=Util.openConnection(con);
                        ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");
                        
                        String consulta="select cc.NOMBRE_CUESTIONARIO,cc.COD_CUESTIONARIO_CARGO,cc.TIEMPO_CUESTIONARIO,"+
                                        " cc.FECHA_CUESTIONARIO_INICIO,cc.FECHA_CUESTIONARIO_FINAL"+
                                        " from CUESTIONARIOS_CARGO cc inner join CUESTIONARIOS_CARGO_CARGO ccc on "+
                                        " cc.COD_CUESTIONARIO_CARGO=ccc.COD_CUESTIONARIO_CARGO inner join personal p on"+
                                        " ccc.COD_CARGO=p.CODIGO_CARGO "+
                                        " where p.COD_PERSONAL='"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"'"+
                                        " order by cc.NOMBRE_CUESTIONARIO";
                        System.out.println("consulta cargar doc personal "+consulta);
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta);
                        SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
                        SimpleDateFormat horas=new SimpleDateFormat("HH:mm");
                        while(res.next())
                        {
                            out.println("<tr>" +
                                    "<td class='outputText2'>&nbsp;"+res.getString("NOMBRE_CUESTIONARIO")+"</td>" +
                                    "<td class='outputText2'>&nbsp;"+res.getString("TIEMPO_CUESTIONARIO")+" min</td>" +
                                    "<td class='outputText2'>&nbsp;"+sdf.format(res.getTimestamp("FECHA_CUESTIONARIO_INICIO"))+"<br>De: "+horas.format(res.getTimestamp("FECHA_CUESTIONARIO_INICIO"))+" a "+horas.format(res.getTimestamp("FECHA_CUESTIONARIO_FINAL"))+"</td>"+
                                    "<td class='outputText2' align='center'><a onclick=\"verDocumento('"+res.getString("COD_CUESTIONARIO_CARGO")+"','"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"')\" href='#'><img src='../../img/folder_32.png' alt='Ver Documento'></td>"+//"','"+res.getString("cod_compprod")+"','"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"','"+res.getString("nro_preguntas")+"'
                                    "</tr>");
                        }
                        res.close();
                        st.close();
                        con.close();
                    }
                    catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
                    %>
            </table>
        
            </div>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js" ></script>
    </body>
</html>