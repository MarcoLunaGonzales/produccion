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
            <link rel="STYLESHEET" type="text/css" href="../../reponse/css/foundation.css" />
            <link rel="STYLESHEET" type="text/css" href="../../reponse/css/AtlasWeb.css" />
            
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
                    
                    window.location.href='registroTiempoIndirectos.jsf?codActividad='+codActividad+
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
                                   
                            </div>
                        </div>
                        <div class="row">
                        <div  class="divContentClass large-12 medium-12 small-12 columns ">
                            <div class="row" >
                                    <div class="large-12 medium-12 small-12 columns large-centered medium-centered small-centered">
                                        
                            <%
                            try
                            {
                                System.out.println("ca "+request.getParameter("ca"));
                                String codAreaEmpresa=request.getParameter("ca");
                                String codPersonal=request.getParameter("p");
                                Connection con=null;
                                con=Util.openConnection(con);
                                SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd");
                                String consulta="select a.ORDEN,a.COD_ACTIVIDAD,a.COD_ESTADO_REGISTRO,ap.NOMBRE_ACTIVIDAD,a.COD_AREA_EMPRESA,e.NOMBRE_ESTADO_REGISTRO,a.HORAS_HOMBRE " +
                                                ",pendiente.pendiente,registrado.registrado" +
                                                " from ACTIVIDADES_PROGRAMA_PRODUCCION_INDIRECTO a  " +
                                                " inner join ESTADOS_REFERENCIALES e on e.COD_ESTADO_REGISTRO = a.COD_ESTADO_REGISTRO " +
                                                " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD = a.COD_ACTIVIDAD and ap.COD_TIPO_ACTIVIDAD = 2 " +
                                                " OUTER APPLY( select count(*) as pendiente from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL sppi where " +
                                                " a.COD_AREA_EMPRESA=sppi.COD_AREA_EMPRESA and "+
                                                " sppi.COD_ACTVIDAD=a.COD_ACTIVIDAD  and sppi.REGISTRO_CERRADO=0 and sppi.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00') pendiente" +
                                                " OUTER APPLY(select count(*) as registrado from SEGUIMIENTO_PROGRAMA_PRODUCCION_INDIRECTO_PERSONAL sppi1"+
                                                " where a.COD_AREA_EMPRESA=sppi1.COD_AREA_EMPRESA and  sppi1.COD_ACTVIDAD = a.COD_ACTIVIDAD  and sppi1.REGISTRO_CERRADO = 1 and sppi1.FECHA_INICIO>'"+sdf.format(new Date())+" 00:00') registrado" +
                                                " where ap.COD_ESTADO_REGISTRO = 1 and a.COD_AREA_EMPRESA = '"+codAreaEmpresa+"'" +
                                                " order by a.ORDEN";
                                System.out.println("consulta actividades "+consulta);
                                Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet res=st.executeQuery(consulta);
                                while(res.next())
                                {
                                    out.println("<div class='row' align='center' >"+
                                                " <div class='columns "+(res.getInt("pendiente")>0?"divOptionOrange":(res.getInt("registrado")>0?"divOptionGreen":"divOptionGrey"))+"' onclick='registroTiemposIndirectosPersonal("+res.getInt("COD_ACTIVIDAD")+")'>"+res.getString("NOMBRE_ACTIVIDAD")+"</div>"+
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

