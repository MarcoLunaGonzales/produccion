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
        String codAreaEmpresa=request.getParameter("codAreaEmpresa");
                try
                {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select f.abreviatura_forma,p.nombre_prod,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
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
                    {%>
<section class="main">
                         <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline">Registro de Seguimiento Procesos de Preparado</label>
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


                </section>
                <%
                  }
                %>
                
<div  id="formProgreso"  style="
                padding: 50px;
                background-color: #cccccc;
                position:absolute;
                z-index: 4;
                left:0px;
                top: 0px;
                border :2px solid #3C8BDA;
                width:100%;
                height:100%;
                filter: alpha(opacity=70);
                visibility:hidden;
                opacity: 0.8;" >
                    
</div>
<div id="principal">
        <center>
             <div  id="formsuper"  style="
                padding: 50px;
                background-color: #cccccc;
                position:absolute;
                z-index: 1;
                left:0px;
                top: 0px;
                border :2px solid #3C8BDA;
                width:100%;
                height:100%;
                filter: alpha(opacity=70);
                visibility:hidden;
                opacity: 0.8;" >
                
          </div>


            <div class="row"  id="divDetalle" style="
               
                z-index: 2;
                top: 12px;
                position:absolute;
                
                visibility:hidden;
                overflow:auto;
                text-align:center;"  >
                    <div class="large-6 medium-8 small-12 large-centered medium-centered small-centered columns">
                        <div class="row" >
                          <div class='divHeaderClass large-12 medium-12 small-12 columns'   ><%--onmousedown="comienzoMovimiento(event, 'divDetalle')"--%>
                              <label  class="inline" onmousedown="comienzoMovimiento(event, 'divDetalle')" > Registro de Seguimiento Por Personal</label>
                           </div>
                        </div>
                        <div class="row">
                            <div class="divContentClass large-12 medium-12 small-12 columns" id="panelSeguimiento"  >
                                <div class="row" style="margin-top:2%">
                                    <div class="large-5 medium-5 small-5 columns">
                                        <span class='textHeaderClassBody' style="font-size:16px;" onclick='cambiarValor1()' >Conforme:</span>
                                    </div>
                                    <div class="large-7 medium-7 small-7 columns">
                                        <input type='checkbox' id='conforme' style="width:20px;height:20px" onclick='cambiarValor1()'>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="large-5 medium-5 small-5 columns">
                                        <span class='textHeaderClassBody' style="font-size:16px;" onclick="cambiarValor2()" >No Conforme:</span>
                                    </div>
                                    <div class="large-7 medium-7 small-7 columns">
                                        <input type='checkbox' id='noconforme' style="width:20px;height:20px" onclick='cambiarValor2()'>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="large-5 medium-5 small-5 columns">
                                        <span class='textHeaderClassBody' style="font-size:16px;" >Responsable :</span>
                                    </div>
                                    <div class="large-7 medium-7 small-7 columns">
                                        <select id='codResponsable' >
                                            <option value='0'>-Ninguno-</option>
                                        </select>
                                    </div>
                                </div>
                                 <div class="row">
                                        <div class="large-8 small-10 medium-12 large-centered medium-centered columns">
                                            <div class="row">
                                                <div class="large-6 medium-6 small-12 columns">
                                                    <input type="button"  class="small button succes radius" onclick="guardarSeguimiento();" value="Guardar"/>
                                                 </div>
                                                    <div class="large-6 medium-6 small-12  columns">
                                                        <input type="button"  class="small button succes radius" onclick="ocultarSeguimiento();" value="Cancelar"/>
                                                    
                                                    </div>
                                            </div>
                                        </div>
                                    </div>
                              </div>
                        </div>
                    </div>
          </div>

             <div class="row">
            <div id="diagrama" class="large-12 medium-12 small-12 columns" 
            style="margin-top:1%; border:1px solid #a80077;border-bottom-left-radius: 10px;border-bottom-right-radius: 10px;
            border-top-left-radius: 10px;border-top-right-radius: 10px; "></div></center>
            </div>
        <input type="hidden" value="<%=cantPixeles%>" id="tamTexto"/>
        <script type="text/javascript">

            var uml = Joint.dia.uml;
            var fd=Joint.point;
            <%
                consulta="select ppd.CODIGO_DIAGRAMA,ppd.variables from PROCESOS_PRODUCTO_DIAGRAMA ppd where ppd.COD_COMPPROD='"+codCompProd+"'";
                System.out.println("consulta cargarDiagrama "+consulta);
                res=st.executeQuery(consulta);

                String codigo="";
                String var="";
                if(res.next())
                {
                    codigo=res.getString("CODIGO_DIAGRAMA");
                    var=res.getString("variables");
                    //out.println();
                }
                String[] variables=var.split(",");
                out.println(codigo);
                consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal"+
                         " from PERSONAL p where p.COD_AREA_EMPRESA='"+codAreaEmpresa+"' order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA";
                System.out.println("consula personal "+consulta);
                String personalSelect="";
                res=st.executeQuery(consulta);
                while(res.next())
                {
                    personalSelect+=(personalSelect.equals("")?"":",")+res.getString("COD_PERSONAL")+",'"+res.getString("nombrePersonal")+"'";

                }
                out.println("personalSelect=new Array("+personalSelect+");codLote="+codLote+";");
                consulta="select s.COD_PROCESO_PRODUCTO,s.COD_SUB_PROCESO_PRODUCTO,pp.COD_PERSONAL,(pp.AP_PATERNO_PERSONAL+' '+pp.AP_MATERNO_PERSONAL+' '+pp.NOMBRE_PILA)as nombre,s.CONFORME" +
                        " from SEGUIMIENTO_PROCESOS_PREPARADO_LOTE s left outer join PROCESOS_PRODUCTO p on"+
                         " p.COD_PROCESO_PRODUCTO=s.COD_PROCESO_PRODUCTO left outer join SUB_PROCESOS_PRODUCTO spp"+
                         " on spp.COD_PROCESO_PRODUCTO=s.COD_PROCESO_PRODUCTO and spp.COD_SUB_PROCESO_PRODUCTO=s.COD_SUB_PROCESO_PRODUCTO" +
                         " inner join PERSONAL pp on pp.COD_PERSONAL=s.COD_PERSONAL" +
                         " where s.COD_LOTE='"+codLote+"'"+
                         " order by p.NRO_PASO,ISNULL(spp.NRO_PASO,0)";
                System.out.println("consulta buscar "+consulta);
                res=st.executeQuery(consulta);
                String codP="";
                while(res.next())
                {
                    codP+=(codP.equals("")?"":",")+res.getString("COD_PROCESO_PRODUCTO")+","+res.getString("COD_SUB_PROCESO_PRODUCTO")+
                            ","+res.getString("COD_PERSONAL")+",'"+res.getString("nombre")+"',"+res.getString("CONFORME");
                }
                for(String var1:variables)
                {
                    out.println(var1+".asignarOperario(new Array("+codP+"));");
                   // System.out.println(var1+".asignarOperario(new Array("+codP+"))");
                }
                //System.out.println("cod "+personalSelect);
                res.close();
                st.close();
                con.close();

            }
            catch(SQLException ex)
            {
                ex.printStackTrace();
            }
            %>

       </script>
</div>
    </body>
</html>
