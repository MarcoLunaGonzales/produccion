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
<%@ page import="java.lang.Math" %>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page language="java" import = "org.joda.time.*"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
   <head>
      <style>
          .d{
              cursor:crosshair
          }
      </style>

<script src="../reponse/js/scripts.js"></script>
<link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
<link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />

<link rel="STYLESHEET" type="text/css" href="../reponse/css/border-radius.css" />
<link rel="STYLESHEET" type="text/css" href="../reponse/css/jscal2.css" />
<link rel="STYLESHEET" type="text/css" href="../reponse/css/gold.css" />
<link rel="STYLESHEET" type="text/css" href="../reponse/css/timePickerCSs.css" />
<script src="../reponse/js/jscal2.js"></script>
<script src="../reponse/js/en.js"></script>
<script src="../reponse/js/websql.js"></script>
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
<script type="text/javascript">
    var operariosRegistro="";
    var fechaNuevoRegistro="";
    function nuevoAjax()
            {	var xmlhttp=false;
                try {
                    xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                } catch (e) {
                    try {
                        xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch (E) {
                        xmlhttp = false;
                    }
                }
                if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                    xmlhttp = new XMLHttpRequest();
                }

                return xmlhttp;
            }
    function transformDate(fecha)
    {
        var fechaTexto=fecha.getFullYear()+"/";
        fechaTexto+=(fecha.getMonth()>=9?"":"0")+(fecha.getMonth()+1)+"/";
        fechaTexto+=(fecha.getDate()>9?"":"0")+fecha.getDate()+" ";
        fechaTexto+=(fecha.getHours()>9?"":"0")+fecha.getHours()+":";
        fechaTexto+=(fecha.getMinutes()>9?"":"0")+fecha.getMinutes();
        return fechaTexto;
    }
    function redondeo2decimales(numero)
    {
        var original=parseFloat(numero);
        var result=Math.round(original*100)/100 ;
        return result;
    }
    function openPopup(url){
        var a=Math.random();
        console.log('ventana abrir '+url);
        var name="registro touch"+Math.random();
        window.open(url+'&a='+a,name,'top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
    }
    function verReporte()
    {
        var url='reporteTiemposPersonal.jsf?codPersonal='+document.getElementById("codPersonalBuscar").value+
            '&fechaInicio='+document.getElementById("fechaInicio").value+"&fechaFinal="+document.getElementById("fechaFinal").value+
            '&codArea='+document.getElementById("codAreaEmpresa").value+'&codtrandom='+(Math.random())+
            '&nombrePersonal='+
            document.getElementById("codPersonalBuscar").options[document.getElementById("codPersonalBuscar").selectedIndex].innerHTML;
        openPopup(url);
    }
    
</script>


</head>
    <body >
        <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../reponse/img/load2.gif"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
         </center>
         </div>
      
  <%
        String codLote=request.getParameter("codLote");
        out.println("<title>FILTRO REPORTE TIEMPOS</title>");
        int codAreaEmpresa=Integer.valueOf(request.getParameter("codArea"));
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        format.applyPattern("#,##0.00");
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String consulta=" select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                           " from personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL"+
                           " where pa.cod_area_empresa in ("+codAreaEmpresa+") AND p.COD_ESTADO_PERSONA = 1 union"+
                           " select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                           " from personal p where p.cod_area_empresa in ("+codAreaEmpresa+") and p.COD_ESTADO_PERSONA = 1 order by NOMBRES_PERSONAL ";
            System.out.println("consulta cargar personal area"+consulta);
            ResultSet res=st.executeQuery(consulta);
            String personalArea="<option value='0'>--Todos--</option>";
            while(res.next())
            {
                personalArea+="<option value='"+res.getInt("COD_PERSONAL")+"'>"+res.getString("NOMBRES_PERSONAL")+"</option>";
            }

            %>

<section class="main">
                      
        <div class="row"  style="margin-top:5px" >
                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >
                        <div class="row">
                           <div class="large-12 medium-12 small-12 columns divHeaderClass" >

                                   <label  class="inline">REPORTE DE TIEMPOS DE PERSONAL</label>
                            </div>
                        </div>
                        <div class="row divContentClass">
                           <div class="large-10 medium-10 small-10 large-centered medium-centered small-centered columns " >
                               <center>
                                   <table cellpadding="0" cellspacing="0"  style="border:none;margin-top:1em;" >
                                       <tr><td class="tableHeaderClass" colspan="3">
                                           <span class="textHeaderClass">Filtro</span></td></tr>
                                       <tr>
                                       <td style="border-left:1px solid #a80077;" ><span class="textHeaderClassBody">Personal</span></td>
                                       <td ><span class="textHeaderClassBody">::</span></td>
                                       <td style="border-right:1px solid #a80077;" ><select id="codPersonalBuscar">
                                           <%
                                           out.println(personalArea);
                                           %>
                                            </select></td>
                                       </tr>
                                       <tr>
                                       <td style="border-left:1px solid #a80077"><span class="textHeaderClassBody">Fecha Inicio</span></td>
                                       <td ><span class="textHeaderClassBody">::</span></td>
                                       <td style="border-right:1px solid #a80077"><input type="tel" id="fechaInicio" value="<%=(sdfDias.format(new Date()))%>"/></td>
                                       <script>Calendar.setup({trigger    : fechaInicio,inputField :fechaInicio,onSelect   : function() { this.hide() }});</script>
                                       </tr>
                                       <tr>
                                       <td style="border-left:1px solid #a80077"><span class="textHeaderClassBody">Fecha Final</span></td>
                                       <td ><span class="textHeaderClassBody">::</span></td>
                                       <td style="border-right:1px solid #a80077"><input type="tel" id="fechaFinal" value="<%=(sdfDias.format(new Date()))%>"/></td>
                                       <script>Calendar.setup({trigger    : fechaFinal,inputField :fechaFinal,onSelect   : function() { this.hide() }});</script>
                                       </tr>
                                       <tr>
                                       <td style="border-right:1px solid #a80077;border-left:1px solid #a80077;border-bottom:1px solid #a80077;border-bottom-left-radius: 10px;border-bottom-right-radius: 10px;" colspan="3">
                                           <div class="row" style="margin-top:0px;">
                                                    <div class="large-10 small-10 medium-12 large-centered medium-centered columns">
                                                        <div class="row">
                                                            <div class="large-6 medium-6 small-12 columns">
                                                                <button class="small button succes radius buttonAction" onclick="verReporte();" >Ver Reporte</button>
                                                            </div>
                                                                <div class="large-6 medium-6 small-12  columns">
                                                                    <button class="small button succes radius buttonAction" onclick="window.close();" >Cancelar</button>

                                                                </div>
                                                        </div>
                                                    </div>
                                            </div>
                                       </td>
                                       </tr>

                                   </table>
                                </center>
                            </div>
                        </div>
                        
        </div>
        </div>
            <%
                }
                catch(SQLException ex)
                {
                    ex.printStackTrace();
                }
            %>
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
          <input type="hidden" id="codAreaEmpresa" value="<%=(codAreaEmpresa)%>"/>
        </section>
    </body>
    <script src="../reponse/js/timePickerJs.js"></script>
</html>
