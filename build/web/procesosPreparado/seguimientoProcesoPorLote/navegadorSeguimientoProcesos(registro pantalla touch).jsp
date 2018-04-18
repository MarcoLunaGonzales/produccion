
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
<script type="text/javascript" src="libJs/joint.all.min(registro pantalla touch).js"></script>
<script src="libJs/scripts.js"></script>
<link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
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
        <%
        int cantPixeles=0;
        String codCompProd=request.getParameter("codComprod");
        String codLote=request.getParameter("codLote");
        String nombreComponente="as";
        String nombreAreaEmpresa="as";
        String codAreaEmpresa=request.getParameter("codAreaEmpresa");
        %>
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
                width :100%;
                height: 100%;
                filter: alpha(opacity=70);
                visibility:hidden;
                opacity: 0.8;" >
                    
          </div>


            <div  id="divDetalle" style="
               background-color: #FFFFFF;
                z-index: 2;
                top: 12px;
                position:absolute;
                left:450px;
                border :2px solid #FFFFFF;
                width :350px;
                height: 200px;
                visibility:hidden;
                overflow:auto;
                text-align:center;"  >
              <div class='headerClassACliente' onmouseover="this.style.cursor='move'" onmousedown="comienzoMovimiento(event, 'divDetalle')"  >Registro de Seguimiento</div>
                        <br>
                            Registro de Seguimiento Por Personal

                        <center><div id="panelSeguimiento" style="overflow:auto;width:330px;height:110px;" >
                           
<table><tr><td class='outputText2'>
        <input type='checkbox' id='conforme' onclick='cambiarValor1()'> </td>
<td align='left'><span class='outputText2' >Conforme</span> </td><tr></tr>
<td><input type='checkbox' id='noconforme' onclick='cambiarValor2()'> </td>
<td align='left'><span class='outputText2'>No Conforme</span> </td>
</tr><tr><td ><span class='outputText2'>Responsable Preparado</span> </td>
<td><select id='codResponsable' class='inputText'>
    <option value='0'>-Ninguno-</option>
    </select></td></tr></table>

                        </div></center>
                    <button class="btn" onclick="guardarSeguimiento();">Guardar</button>
                    <button class="btn" onclick="ocultarSeguimiento()">Cancelar</button>
          </div>




            <table width="70%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >
                 <%
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
                    {
                         Calendar cal = new GregorianCalendar();
                        cal.setTimeInMillis(res.getDate("FECHA_FINAL").getTime());
                        cal.add(Calendar.MONTH, res.getInt("vida_util"));
                        SimpleDateFormat sdf=new SimpleDateFormat("MM-yyyy");
                        
                        Date fecha=new Date(cal.getTimeInMillis());
                        
                        out.println("<tr ><th style='border-bottom: solid #000000 1px;border-right : solid #000000 1px' rowspan='3'><center><img src='../../img/cofar.png'></center></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='outputText2'><b>FORMULA MAESTRA</b></span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center' style='font-style:normal;'><span class='normal'>Número de Página</span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='outputText2'>12</span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='outputText2'><b>de</b></span></th>" +
                                "<th style='border-bottom : solid #000000 1px' align='center'><span class='outputText2'></span></th>" +
                                "</tr>" +
                                "<tr>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center' rowspan='2'><span class='outputText2'><b>PROCESOS DE PREPARACIÓN<br/>(REGISTRO DE SEGUIMIENTO)</b></span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Lote</span></th>" +
                                "<th style='border-bottom: solid #000000 1px;' align='left' colspan='3'><span class='normal'>"+codLote+"</span></th>" +
                                "</tr><tr>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Expiración</span></th>" +
                                "<th style='border-bottom : solid #000000 1px' align='left' colspan='3'><span class='normal'>"+sdf.format(fecha)+"</span></th>" +
                                "</tr><tr>" +
                                "<th  colspan='6' style='border-bottom: solid #000000 1px;' align='left'>&nbsp;</th>" +
                                "</tr><tr>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Nombre Comercial</span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='outputText2'><b>"+res.getString("nombre_prod")+"</b></span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Presentación</span></th>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;' align='left'><span class='normal'>"+res.getString("nombre_envaseprim")+"</span></th>" +
                                "</tr><tr>" +
                                "<th rowspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Nombre Genérico/Concentración</span></th>" +
                                "<th rowspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>"+res.getString("NOMBRE_GENERICO")+"</span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>N° de Registro Sanitario</span></th>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;' align='left'><span class='normal'>"+res.getString("REG_SANITARIO")+"</span></th>" +
                                "</tr><tr>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Vida util del producto</span></th>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;' align='left'><span class='normal'>"+res.getString("vida_util")+" meses</span></th>" +
                                "</tr><tr>" +
                                "<th style='border-right:solid #000000 1px' align='left'><span class='normal'>Forma Farmaceútica</span></th>" +
                                "<th style='border-right:solid #000000 1px' align='left'><span class='normal'>"+res.getString("nombre_forma")+"</span></th>" +
                                "<th style='border-right:solid #000000 1px' align='left'><span class='normal'>Tamaño de Lote Industrial</span></th>" +
                                "<th colspan='2'  style='border-right:solid #000000 1px' align='left'><span class='normal'>"+res.getString("CANT_LOTE_PRODUCCION")+"</span></th>" +
                                "<th align='left'><span class='normal'>"+res.getString("abreviatura_forma").toLowerCase()+"</span></th>" +
                                "</tr>"
                                );
                    }
                %>
                
            </table>

            <div id="diagrama"></div></center>

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
                consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA) as nombrePersonal"+
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
