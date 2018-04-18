package sistemaTouch.registroTiemposAlmacen;

package sistemaTouch.registroTiemposIndirectosProduccion_1;

<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@page import="java.util.Date" %>
<%@page import="java.text.SimpleDateFormat" %>
<f:view>
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
            <style>
                span
                {
                    font-size:1.2em !important;
                }
                span:hover
                {
                    font-size:1.4em;
                }
            </style>
            <script>
                function registroTiemposIndirectosPersonal(codActividad)
                {
                    
                    window.location.href='registroTiempoPersonalIndirecto/registroTiempoIndirectos.jsf?codActividad='+codActividad+
                                         '&p='+(this.parent.codPersonalIndirecta)+
                                         '&cp='+(this.parent.codProgramaProdIndirecta)+
                                         '&ca='+(this.parent.codAreaEmpresaIndirecta)+
                                         '&data='+(new Date()).getTime().toString();
                }
            </script>
        </head>
        <body>
            
            <form>
             
                <section class="main" style="margin-top:1em;width:100%;">
                     <div class="large-6 medium-9 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline" style="margin:0px;">Actividades Indirectas</label>
                                   <center>
                                       <table style="background-color:transparent;" cellpadding="0" cellspacing="0">
                                           <tr>
                                               <td class="textHeaderClass" style="margin:0px">Pendientes de Cerrar</td>
                                               <td class="divOptionOrange" style="width:4em;">&nbsp;</td>
                                           </tr>
                                       </table>
                                   </center>
                            </div>
                        </div>
                        <div class="row">
                        <div  class="divContentClass large-12 medium-12 small-12 columns ">
                            <div class="row" >
                                    <div class="large-12 medium-12 small-12 columns large-centered medium-centered small-centered">
                                        
                            <%
                            try
                            {
                                String codAreaEmpresa=request.getParameter("ca");
                                String codPersonal=request.getParameter("p");
                                Connection con=null;
                                con=Util.openConnection(con);
                                SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
                                String consulta="select a.ORDEN,a.COD_ACTIVIDAD,a.COD_ESTADO_REGISTRO,ap.NOMBRE_ACTIVIDAD,a.COD_AREA_EMPRESA,e.NOMBRE_ESTADO_REGISTRO,a.HORAS_HOMBRE " +
                                                ",pendientes.contador" +
                                                " from ACTIVIDADES_PROGRAMA_PRODUCCION_INDIRECTO a  " +
                                                " inner join ESTADOS_REFERENCIALES e on e.COD_ESTADO_REGISTRO = a.COD_ESTADO_REGISTRO " +
                                                " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD = a.COD_ACTIVIDAD and ap.COD_TIPO_ACTIVIDAD = 2 " +
                                                " OUTER APPLY( select count(*) as contador from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL sppi where "+
                                                " sppi.COD_ACTVIDAD=a.COD_ACTIVIDAD and sppi.COD_PERSONAL='"+codPersonal+"' and sppi.REGISTRO_CERRADO=0) pendientes" +
                                                " where ap.COD_ESTADO_REGISTRO = 1 and a.COD_AREA_EMPRESA = '"+codAreaEmpresa+"'" +
                                                " and  a.COD_ACTIVIDAD in ( select tid.COD_ACTIVIDAD from TAREAS_INDIRECTAS_DIA tid where tid.COD_PERSONAL='"+codPersonal+"'"+
                                                " and tid.FECHA_TAREA BETWEEN '"+sdf.format(new Date())+" 00:00' and '"+sdf.format(new Date())+" 23:59')" +
                                                " order by a.ORDEN";
                                System.out.println("consulta actividades "+consulta);
                                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet res=st.executeQuery(consulta);
                                while(res.next())
                                {
                                    out.println("<div class='row' align='center' >"+
                                                " <div class='columns "+(res.getInt("contador")>0?"divOptionOrange":"divOptionGreen")+"' onclick='registroTiemposIndirectosPersonal("+res.getInt("COD_ACTIVIDAD")+")'>"+
                                                " <span class='textHeaderClass'>"+res.getString("NOMBRE_ACTIVIDAD")+"</span></div>"+
                                                "</div>");
                                }
                                st.close();
                            }
                            catch(SQLException ex)
                            {
                                ex.printStackTrace();
                            }
                            catch(Exception e)
                            {
                                e.printStackTrace();
                            }

                            %>
                                
                                              
                                            
                                             
                                              
                                    </div>
                                </div>
                         </div>
                         </div>
                     </div>
                
                </section>
               
            </form>

        </body>
    </html>
</f:view>


