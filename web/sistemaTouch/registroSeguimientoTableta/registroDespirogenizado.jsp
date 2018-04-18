<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.util.ArrayList"%>
<%@ page import = "java.util.Date"%>
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page language="java" import = "org.joda.time.*"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
   <head>
<script type="text/javascript" src="../reponse/js/joint.js"></script>
<script src="../reponse/js/scripts.js"></script>
<link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
<link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
<style>
    .bold
    {
        font-weight:bold;
        font-family: 'Arial';
        font-size:12px;
        font-style:normal;

    }
    .normal
    {
        font-weight:400;
        font-family: 'Arial';
        font-size:12px;
        font-style:normal;

    }

</style>



</head>
    <body onload="carga();">
      <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../reponse/img/load2.gif"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
         </center>
         </div>
  <%
   int cantPixeles=0;
        String codCompProd=request.getParameter("codComprod");
        String codLote=request.getParameter("codLote");
        String nombreComponente="as";
        String nombreAreaEmpresa="as";
        String codForma="";
        String codAreaEmpresa=request.getParameter("codAreaEmpresa");
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select cp.COD_FORMA,f.abreviatura_forma,p.nombre_prod,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                                    " where pp.COD_LOTE_PRODUCCION='"+codLote+"'";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    if(res.next())
                    {
                        codForma=res.getString("COD_FORMA");
                        %>

<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">Registro de Despirogenizado</label>
                                                </div>
                                            </div>
                                            <div class="row" >
                                                
                                            <div  class="divContentClass large-12 medium-12 small-12 columns">
                                                  
                                                   <table style="width:96%;margin-top:2%" cellpadding="0px" cellspacing="0px">
                                                       <tr >
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Lote</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center;">
                                                               <span class="textHeaderClass">Tam. Lote</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Producto</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Forma Farmaceútica</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Presentación</span>
                                                           </td>
                                                       </tr>
                                                       
                                                       <tr >
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=codLote%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody"><%=res.getDouble("CANT_LOTE_PRODUCCION")%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_prod")%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_forma")%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=res.getString("nombre_envaseprim")%></span>
                                                           </td>
                                                       </tr>
                                                       </table>
                                                   
                                                    
                                             </div>
                                             </div>
                                         </div>
                            </div>




<div class="row"  style="margin-top:5px" >
            <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                   <label  class="inline">Despirogenizado</label>
                            </div>
                        </div>
                        <div class="row" >

                        <div  class="divContentClass large-12 medium-12 small-12 columns">
                
                <%
                    }
                    consulta="select p.NOMBRE_PROCESO,p.CONDICIONES_GENERALES from PROCESOS_FORMULA_MAESTRA p where p.COD_FORMA='"+codForma+"'";
                    System.out.println("consulta cargar condiciones forma "+consulta);
                    res=st.executeQuery(consulta);

                    char b=13;char c=10;

                    if(res.next())
                    {
                        String condiciones=res.getString("CONDICIONES_GENERALES").replace(b,'\n');
                        condiciones=condiciones.replace("\n\n", "<br>");
                        
                        %>
                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns " >
                                   <span class="textHeaderClassBody">Condiciones Generales<br></span>
                                   <span class="textHeaderClassBody" style="font-weight:normal"><%=condiciones.replace(c,' ')%></span>
                            </div>
                        </div>
                         <table style="width:100%;margin-top:2%" cellpadding="0px" cellspacing="0px">
                        <tr >
                               <td class="tableHeaderClass" style="text-align:center" colspan="3">
                                   <span class="textHeaderClass">ESPECIFICACIONES DE ETAPA DE DESPIROGENIZADO</span>
                               </td>
                               <td class="tableHeaderClass" style="text-align:center;" colspan="3">
                                   <span class="textHeaderClass">CONDICCIONES DE ETAPA DE DESPIROGENIZADO</span>
                               </td>
                        </tr>
                         <tr >
                               <td class="tableHeaderClass" style="text-align:center">
                                   <span class="textHeaderClass">&nbsp;</span>
                               </td>
                               <td class="tableHeaderClass" style="text-align:center;">
                                   <span class="textHeaderClass">Valor</span>
                               </td>
                               <td class="tableHeaderClass" style="text-align:center">
                                   <span class="textHeaderClass">Unidad.</span>
                               </td>
                               <td class="tableHeaderClass" style="text-align:center">
                                   <span class="textHeaderClass">&nbsp;</span>
                               </td>
                               <td class="tableHeaderClass" style="text-align:center;">
                                   <span class="textHeaderClass">Valor</span>
                               </td>
                               <td class="tableHeaderClass" style="text-align:center">
                                   <span class="textHeaderClass">Unidad.</span>
                               </td>
                           </tr>
                        <%
                    }
                    consulta="select ep.NOMBRE_ESPECIFICACIONES_PROCESO,"+
                                 " case WHEN ep.ESPECIFICACION_STANDAR_FORMA=1 then ep.VALOR_EXACTO"+
                                " else isnull(epp.VALOR_EXACTO,0) end as valorExacto,"+
                                " case when  ep.ESPECIFICACION_STANDAR_FORMA=1 then ep.VALOR_TEXTO"+
                                " else isnull(epp.VALOR_TEXTO,'') end as valorTexto,"+
                                " ISNULL(um.ABREVIATURA,'N.A.') as nombreUnidad,"+
                                " ep.RESULTADO_NUMERICO"+
                                " from ESPECIFICACIONES_PROCESOS ep "+
                                " left outer join UNIDADES_MEDIDA um on "+
                                " um.COD_UNIDAD_MEDIDA=ep.COD_UNIDAD_MEDIDA"+
                                " left outer join ESPECIFICACIONES_PROCESOS_PRODUCTO epp"+
                                " on ep.COD_ESPECIFICACION_PROCESO=epp.COD_ESPECIFICACION_PROCESO"+
                                " and epp.COD_COMPPROD='"+codCompProd+"'"+
                                " where ep.COD_FORMA='"+codForma+"'"+
                                " order by ep.ORDEN";
                    res=st.executeQuery(consulta);
                    System.out.println("consulta esp "+consulta);
                    String valor="";
                    String nombreEspecificacion="";
                    String unidadMedida="";
                    while(res.next())
                    {
                        
                        valor=(res.getInt("RESULTADO_NUMERICO")>0?(res.getInt("valorExacto")>0?String.valueOf(res.getInt("valorExacto")):""):res.getString("valorTexto"));
                        nombreEspecificacion=res.getString("NOMBRE_ESPECIFICACIONES_PROCESO");
                        unidadMedida=res.getString("nombreUnidad");
                        %>
                        <tr >
                           <td class="tableCell" style="text-align:center">
                               <span class="textHeaderClassBody" style="font-weight:normal"><%=nombreEspecificacion%></span>
                           </td>
                           <td class="tableCell" style="text-align:center;">
                               <span class="textHeaderClassBody" style="font-weight:normal"><%=valor%></span>
                           </td>
                           <td class="tableCell" style="text-align:center">
                               <span class="textHeaderClassBody" style="font-weight:normal"><%=unidadMedida%></span>
                           </td>
                           <td class="tableCell" style="text-align:center">
                               <span class="textHeaderClassBody" style="font-weight:normal"><%=nombreEspecificacion%></span>
                           </td>
                           <td class="tableCell" style="text-align:center">
                               <input class="textHeaderClassBody" type="text"/>
                           </td>
                           <td class="tableCell" style="text-align:center">
                               <span class="textHeaderClassBody" style="font-weight:normal"><%=unidadMedida%></span>
                           </td>
                       </tr>
                        <%
                    }
                    %>
                    </table>
                    <%

                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
                %>
                </div>
            </div>
    </div>
    </div>
        </section>
    </body>
</html>
