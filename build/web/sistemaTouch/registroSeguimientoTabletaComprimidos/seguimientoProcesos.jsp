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

<link rel="STYLESHEET" type="text/css" href="../reponse/css/border-radius.css" />

<link rel="STYLESHEET" type="text/css" href="../reponse/css/jscal2.css" />
<link rel="STYLESHEET" type="text/css" href="../reponse/css/gold.css" />
<script src="../reponse/js/jscal2.js"></script>
<script src="../reponse/js/en.js"></script>
<link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
<link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
<link rel="STYLESHEET" type="text/css" href="../reponse/css/timePickerCSs.css" />

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
function guardarSeguimientoProgramaProduccionComprimidos(adminHoja,codPersonalHoja)
{
    document.getElementById('divImagen').style.visibility='visible';
    document.getElementById('formProgreso').style.visibility='visible';
    var dataSeguimiento=formatArrayGeneral(document.getElementById("registroTiempo"),1,true);
    ajax=nuevoAjax();
    var peticion="ajaxGuardarSeguimientoProgramaProduccion.jsp?&noCache="+ Math.random()+
                "&dataSeguimientoPersonal="+dataSeguimiento+
                "&codFormula="+document.getElementById("codFormula").value+
                "&codProgramaProd="+document.getElementById("codProgramaProd").value+
                "&codTipoProduccion="+document.getElementById("codTipoProduccion").value+
                "&codActividadPrograma="+document.getElementById("codActividadPrograma").value+
                "&codCompProd="+document.getElementById("codCompProd").value+
                "&horasMaquina="+document.getElementById("horasMaquinaActividad").value+
                "&admin="+(adminHoja?"1":"0")+
                "&codPersonalRegistro="+codPersonalHoja+
                (adminHoja?"&observacionLote="+encodeURIComponent(document.getElementById("observacion").value):"")+
                "&codLote="+codLote;
    ajax.open("GET",peticion,true);
    ajax.setRequestHeader('content-type', 'application/x-www-form-urlencoded;charset=UTF-8');
                 ajax.onreadystatechange=function(){
                    if (ajax.readyState==4) {

                        if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                        {
                            alert((adminHoja?'Se cerro la hoja':'Se registraron los tiempos del personal'));
                            ocultarSeguimiento();
							document.getElementById('formProgreso').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                            if(adminHoja)window.close();
                        }
                        else
                        {
                            alert("&"+ajax.responseText.split("\n").join("")+"&");
                            document.getElementById('formProgreso').style.visibility='hidden';
                            document.getElementById('divImagen').style.visibility='hidden';
                        }
                    }
                }

                ajax.send(null);
        return true;
}
function asignarHorasEstandar()
{
    var codMaquina=document.getElementById("codMaquinaActividad").value;
    var aux=document.getElementById(("standar"+codMaquina)).value.split("/");
    document.getElementById("horasHobreStandard").innerHTML=aux[0];
    document.getElementById("horasMaquinaStandard").innerHTML=aux[1];
    
}

var operariosRegistro="";
var contadorRegistroTiempos=0;

onerror=function(){alert('Existe un error guarde la informacion y actualice la pagina');}
</script>


</head>
    <body onload="carga();">
      <div style="margin-top:2%;position:fixed;;width:100%;z-index:5;visibility:hidden" id="divImagen">
         <center><img src="../reponse/img/load2.gif"  style="z-index:6; "><%--margin-top:2%;position:fixed;--%>
         </center>
         </div>
  <%
        int codPersonalApruebaDespeje=0;
        String codPersonal=request.getParameter("codPersonal");
        int codPersonalSupervisor=0;
        boolean administrador=(Integer.valueOf(request.getParameter("admin"))>0);
        out.println("<script type='text/javascript'>codPersonal="+codPersonal+";" +
                   "admin="+administrador+";</script>");
        int codEstadoHoja=0;
        SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
        Date fechaCierre=new Date();
        int cantPixeles=0;
        String observaciones="";
        String codCompProd=request.getParameter("codComprod");
        String codProgramaProd=request.getParameter("cod_prog");
        String codLote=request.getParameter("codLote");
        String codTipoProgramaProd="";
                try
                {
                    NumberFormat nf1 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formato= (DecimalFormat)nf1;
                formato.applyPattern("####.#####");
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select f.cod_forma,pp.COD_FORMULA_MAESTRA,cp.COD_COMPPROD,f.abreviatura_forma,p.nombre_prod,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL,cp.cod_area_empresa" +
                                    " ,cp.PESO_ENVASE_PRIMARIO,tpp.ABREVIATURA as abtp,isnull((cast (cp.CANTIDAD_VOLUMEN as varchar) + ' ' + um.ABREVIATURA),'') as VOLUMEN_ENVASE_PRIMARIO," +
                                    "fm.CANTIDAD_LOTE,ppm.CANTIDAD,cpm.NOMBRE_COLORPRESPRIMARIA,pp.COD_TIPO_PROGRAMA_PROD" +
                                    ",isnull(sppl.COD_ESTADO_HOJA,0) as COD_ESTADO_HOJA,isnull(sppl.OBSERVACION,0) as observacionLote,"+
                                    " isnull(sppl.COD_PERSONAL_SUPERVISOR,0)as COD_PERSONAL_SUPERVISOR,sppl.FECHA_CIERRE" +
                                    " ,isnull(conjunta.cantAsociada,0) as cantAsociada,isnull(conjunta.loteAsociado,'') as loteAsociado" +
                                    " ,isnull(sppl.COD_PERSONAL_APRUEBA_DESPEJE,0) as COD_PERSONAL_APRUEBA_DESPEJE"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_ESTADO_REGISTRO=1 and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                                    " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD" +
                                    " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA" +
                                    " left outer join COLORES_PRESPRIMARIA cpm on cpm.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA" +
                                    " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =cp.COD_UNIDAD_MEDIDA_VOLUMEN" +
                                    " left outer join SEGUIMIENTO_PREPARADO_LOTE sppl on sppl.cod_lote=pp.COD_LOTE_PRODUCCION"+
                                    " and sppl.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD" +
                                    " outer APPLY(select top 1 ppc.CANT_LOTE_PRODUCCION as cantAsociada,ppc.COD_LOTE_PRODUCCION as loteAsociado from LOTES_PRODUCCION_CONJUNTA lpc inner join PROGRAMA_PRODUCCION ppc on"+
                                    " ppc.COD_LOTE_PRODUCCION=lpc.COD_LOTE_PRODUCCION_ASOCIADO and ppc.COD_PROGRAMA_PROD=lpc.COD_PROGRAMA_PROD"+
                                    " where lpc.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION and lpc.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD)conjunta"+
                                    " where pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.cod_programa_prod='"+codProgramaProd+"' order by tpp.COD_TIPO_PROGRAMA_PROD,ppp.FECHA_FINAL desc";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    SimpleDateFormat sdf=new SimpleDateFormat("MM-yyyy");
                    Date fecha=null;
                    String nombreProd="";
                    String nombreEnvasePrimario="";
                    String nombreGenerico="";
                    String registroSanitario="";
                    String vidaUtil="";
                    String nombreForma="";
                    String tamLote="";
                    String loteAsociado="";
                    double cantidadAsociada=0;
                    double rendimientoAsociado=0;
                    String abreviaturaForma="";
                    String abreviaturaTP="ABREVIATURA";
                    String codComprodMix="";
                    Double[] prod1=new Double[4];
                    Double[] prod2=new Double[4];
                    int codForma=0;
                    String nombreColor="";
                    String volumenEnvasePrimario="";
                    String cantidadEnvasePrimario="";
                    String pesoEnvasePrimario="";
                    String codFormulaMaestra="";
                    if(res.next())
                    {
                        codPersonalApruebaDespeje=res.getInt("COD_PERSONAL_APRUEBA_DESPEJE");
                        loteAsociado=res.getString("loteAsociado");
                        cantidadAsociada=res.getDouble("cantAsociada");
                        observaciones=res.getString("observacionLote");
                        fechaCierre=(res.getTimestamp("FECHA_CIERRE")!=null?res.getTimestamp("FECHA_CIERRE"):new Date());
                        codEstadoHoja=res.getInt("COD_ESTADO_HOJA");
                        codPersonalSupervisor=res.getInt("COD_PERSONAL_SUPERVISOR");
                        codComprodMix=res.getString("COD_COMPPROD");
                        prod1[0]=res.getDouble("COD_COMPPROD");
                        
                        prod1[1]=(res.getDouble("CANT_LOTE_PRODUCCION")/res.getDouble("CANTIDAD_LOTE"));
                        rendimientoAsociado=(res.getDouble("cantAsociada")/res.getDouble("CANTIDAD_LOTE"));
                        prod1[2]=res.getDouble("COD_FORMULA_MAESTRA");
                        
                        prod1[3]=res.getDouble("COD_TIPO_PROGRAMA_PROD");
                        volumenEnvasePrimario=res.getString("VOLUMEN_ENVASE_PRIMARIO").toLowerCase();;
                        abreviaturaTP=res.getString("abtp");
                        
                        
                        if(res.getDate("FECHA_FINAL")!=null)
                            {
                         Calendar cal = new GregorianCalendar();
                        cal.setTimeInMillis(res.getDate("FECHA_FINAL").getTime());
                        cal.add(Calendar.MONTH, res.getInt("vida_util"));


                       fecha=new Date(cal.getTimeInMillis());
                        }
                        if(res.getString("cod_area_empresa").equals("81"))
                            {
                        consulta="select FECHA_VENCIMIENTO from INGRESOS_ALMACEN_DETALLE_ESTADO i inner join FORMULA_MAESTRA_DETALLE_EP fmdep on fmdep.COD_MATERIAL = i.COD_MATERIAL" +
                                " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = fmdep.COD_FORMULA_MAESTRA inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD " +
                                " where i.LOTE_MATERIAL_PROVEEDOR = '"+codLote+"' ";
                                Statement stdetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                ResultSet resDet=stdetalle.executeQuery(consulta);
                                if(resDet.next())
                                {
                                    fecha=resDet.getDate("FECHA_VENCIMIENTO");
                                }
                                resDet.close();
                                stdetalle.close();
                        }
                            pesoEnvasePrimario=res.getString("PESO_ENVASE_PRIMARIO");
                            cantidadEnvasePrimario=res.getString("CANTIDAD");
                            nombreColor=res.getString("NOMBRE_COLORPRESPRIMARIA");
                            codForma=res.getInt("cod_forma");
                            nombreForma=res.getString("nombre_forma");
                            nombreProd=res.getString("nombre_prod");
                            nombreEnvasePrimario=res.getString("nombre_envaseprim").toLowerCase();
                            nombreEnvasePrimario+=((codForma==2||codForma==14||codForma==33||codForma==16|| codForma==10||codForma==26||codForma==27||codForma==29)?" "+nombreColor+" por "+volumenEnvasePrimario:
                                                  ((codForma==6||codForma==1||codForma==32)?" por "+cantidadEnvasePrimario+" "+nombreForma.toLowerCase():
                                                 ((codForma==7||codForma==25)?" por "+volumenEnvasePrimario:
                                                 ((codForma==12||codForma==20||codForma==31||codForma==11||codForma==34||codForma==30||codForma==13)?" por "+pesoEnvasePrimario:
                                                  ((codForma==36)?" por "+cantidadEnvasePrimario+"comprimidos":"") ))));

                            nombreGenerico=res.getString("NOMBRE_GENERICO");
                            registroSanitario=res.getString("REG_SANITARIO");
                            vidaUtil=res.getString("vida_util");

                            tamLote=res.getString("CANT_LOTE_PRODUCCION");
                            abreviaturaForma=res.getString("abreviatura_forma").toLowerCase();
                       }
                       if(res.next())
                       {
                           
                            prod2[0]=res.getDouble("COD_COMPPROD");
                            prod2[1]=(res.getDouble("CANT_LOTE_PRODUCCION")/res.getDouble("CANTIDAD_LOTE"));
                            prod2[2]=res.getDouble("COD_FORMULA_MAESTRA");
                            prod2[3]=res.getDouble("COD_TIPO_PROGRAMA_PROD");
                           if(!codComprodMix.equals(res.getString("COD_COMPPROD")))
                           {
                               codComprodMix+=","+res.getString("COD_COMPPROD");
                           /*    if(prod2[0]!=res.getDouble("COD_COMPPROD"))
                               {
                                   Double[] aux= new Double[2];
                                   aux[0]=prod1[0];
                                   aux[1]=prod1[1];
                                   aux[2]=prod1[2];
                                   prod1[0]=prod2[0];
                                   prod1[1]=prod2[1];
                                   prod1[2]=prod2[2];
                                   prod2[0]=aux[0];
                                   prod2[1]=aux[1];
                                   prod2[2]=aux[2];
                               }*/

                           }
                           nombreEnvasePrimario+=" ("+abreviaturaTP+") y "+res.getString("nombre_envaseprim").toLowerCase();
                            pesoEnvasePrimario=res.getString("PESO_ENVASE_PRIMARIO");
                            cantidadEnvasePrimario=res.getString("CANTIDAD");
                            nombreColor=res.getString("NOMBRE_COLORPRESPRIMARIA");
                            codForma=res.getInt("cod_forma");
                            nombreForma=res.getString("nombre_forma");
                            nombreProd=res.getString("nombre_prod");
                            nombreEnvasePrimario+=((codForma==2||codForma==14||codForma==33||codForma==16|| codForma==10||codForma==26||codForma==27||codForma==29)?" "+nombreColor+" por "+volumenEnvasePrimario:
                                                  ((codForma==6||codForma==1||codForma==32)?" por "+cantidadEnvasePrimario+" "+nombreForma.toLowerCase():
                                                 ((codForma==7||codForma==25)?" por "+volumenEnvasePrimario:
                                                 ((codForma==12||codForma==20||codForma==31||codForma==11||codForma==34||codForma==30||codForma==13)?" por "+pesoEnvasePrimario:
                                                  ((codForma==36)?" por "+cantidadEnvasePrimario+"comprimidos":"") ))))+"("+res.getString("abtp")+")";

                                   //+" x "+res.getString("VOLUMEN_ENVASE_PRIMARIO").toLowerCase()+" "+res.getString("abtp");
                           tamLote+=" "+abreviaturaTP+" - "+res.getString("CANT_LOTE_PRODUCCION")+" "+res.getString("abtp");
                       }
                    
                    consulta="select m.NOMBRE_CCC,cpc.CANTIDAD,um.ABREVIATURA,cpc.UNIDAD_PRODUCTO" +
                                                    ",cpc.NOMBRE_MATERIAL_EQUIVALENCIA,cpc.CANTIDAD_EQUIVALENCIA,isnull(ume.ABREVIATURA,'') as abreEquivalencia"+
                                                     " from COMPONENTES_PROD_CONCENTRACION cpc inner join materiales m"+
                                                     " on cpc.COD_MATERIAL=m.COD_MATERIAL inner join UNIDADES_MEDIDA um on "+
                                                     " um.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA" +
                                                     " left outer join UNIDADES_MEDIDA ume on ume.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA"+
                                                     " where cpc.COD_ESTADO_REGISTRO=1 and cpc.COD_COMPPROD='"+codCompProd+"'"+
                                                     " order by m.NOMBRE_CCC";
                                            System.out.println("consulta concentracion "+consulta);
                                            res=st.executeQuery(consulta);
                                            String concentracion="";
                                            String porUnidadProd="";
                                            if(res.next())
                                            {
                                                concentracion=res.getString("NOMBRE_CCC")+" "+formato.format(res.getDouble("CANTIDAD"))+" "+res.getString("ABREVIATURA");
                                                concentracion+=(res.getInt("CANTIDAD_EQUIVALENCIA")>0?(" equivalente a "+res.getString("NOMBRE_MATERIAL_EQUIVALENCIA")+" "+formato.format(res.getDouble("CANTIDAD_EQUIVALENCIA"))+" "+res.getString("abreEquivalencia")):"");
                                                porUnidadProd=res.getString("UNIDAD_PRODUCTO");
                                            }
                                            while(res.next())
                                            {
                                                concentracion+=", "+res.getString("NOMBRE_CCC")+" "+formato.format(res.getDouble("CANTIDAD"))+" "+res.getString("ABREVIATURA");//res.getString("datoMaterial");
                                                concentracion+=(res.getInt("CANTIDAD_EQUIVALENCIA")>0?(" equivalente a "+res.getString("NOMBRE_MATERIAL_EQUIVALENCIA")+" "+formato.format(res.getDouble("CANTIDAD_EQUIVALENCIA"))+" "+res.getString("abreEquivalencia")):"");
                                            }
                                            concentracion+=(porUnidadProd.equals("")?"":" / ")+porUnidadProd;

                        
                        %>
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
                                                               <span class="textHeaderClassBody"><%=(codLote+(loteAsociado.equals("")?"":"<br>"+loteAsociado))%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center;">
                                                               <span class="textHeaderClassBody"><%=(tamLote+(cantidadAsociada>0?"<br>"+cantidadAsociada:""))%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=(nombreProd)%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=(nombreForma)%></span>
                                                           </td>
                                                           <td class="tableCell" style="text-align:center">
                                                               <span class="textHeaderClassBody"><%=(nombreEnvasePrimario)%></span>
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
                                   <label  class="inline">DESPEJE DE LINEA DE PREPARADO</label>
                            </div>
                        </div>
                         <div class="row" >
                            <div  class="divContentClass large-12 medium-12 small-12 columns" style="padding-top:1em;">
                                <span >Realizar segun POE PRO-LES-IN-017 "DESPEJE DE LINEA DE TRABAJO"<br><br>Realizar el despeje de linea y solicitar al Jefe de area la aprobacion de la seccion de trabajo.</span>
                                <%
                                 consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonalAprueba"+
                                          " from personal p where p.COD_PERSONAL='"+codPersonalApruebaDespeje+"'";
                                 res=st.executeQuery(consulta);
                                 String nombreDespeje="Sin Aprobacion";
                                 if(res.next())
                                 {
                                    nombreDespeje=res.getString("nombrePersonalAprueba");
                                    codPersonalApruebaDespeje=res.getInt("COD_PERSONAL");
                                 }
                                 out.println("<br><br><span style='font-weight:bold'>Aprobado por:</span><span>&nbsp;&nbsp;&nbsp;"+nombreDespeje+"</span><br><br>");


                                %>

                            </div>
                         </div>


            </div>
</div>

                </section>
         
                
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
                    <div class="large-7 medium-9 small-12 large-centered medium-centered small-centered columns">
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
                                    <div class="large-5 medium-5 small-5 columns">
                                        <span class='textHeaderClassBody' style="font-size:16px;" >Responsable 2:</span>
                                    </div>
                                    <div class="large-7 medium-7 small-7 columns">
                                        <select id='codResponsable2' >
                                            <option value='0'>-Ninguno-</option>
                                        </select>
                                    </div>
                                </div>
                                 <div class="row">
                                    <div class="large-5 medium-5 small-5 columns">
                                        <span class='textHeaderClassBody' style="font-size:16px;" >Observaciones</span>
                                    </div>
                                    <div class="large-7 medium-7 small-7 columns">
                                        <textarea id="observaciones" style="width:100%"></textarea>
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
                boolean loteMix=false;
                loteMix=codComprodMix.split(",").length>1;
                if(loteMix)
                {
                    consulta="select case when cpm.NRO_COMPPROD_DIAGRAMA_PREPARADO=1 then"+
                             " cpm.COD_COMPROD1 else cpm.COD_COMPROD2 end as codDiagrama"+
                             " from COMPONENTES_PROD_MIX cpm where cpm.COD_COMPROD_MIX='"+codCompProd+"'";
                    System.out.println("consulta codComprodMix "+consulta);
                    res=st.executeQuery(consulta);
                    if(res.next())
                    {
                        codCompProd=res.getString("codDiagrama");
                    }
                    else
                    {
                        out.println("<script>alert('No se definio el lote mix,solicite a Dirección Técnica');</script>");
                    }
                    if(Double.parseDouble(codCompProd)!=prod1[0])
                    {
                        Double[] aux= new Double[4];
                       aux[0]=prod1[0];
                       aux[1]=prod1[1];
                       aux[2]=prod1[2];
                       aux[3]=prod1[3];
                       prod1[0]=prod2[0];
                       prod1[1]=prod2[1];
                       prod1[2]=prod2[2];
                       prod1[3]=prod2[3];
                       prod2[0]=aux[0];
                       prod2[1]=aux[1];
                       prod2[2]=aux[2];
                       prod2[3]=aux[3];
                    }
                }
                else
                {
                    codCompProd=String.valueOf(prod1[0].intValue());
                }
                if(cantidadAsociada>0)prod1[1]=prod1[1]+rendimientoAsociado;
                
                        char b=13;char c=10;
                     consulta="select pp.COD_PROCESO_PRODUCTO,pp.OPERARIO_TIEMPO_COMPLETO,pp.descripcion,pp.TIEMPO_PROCESO,pp.COD_PROCESO_PRODUCTO,pp.NRO_PASO,ap.NOMBRE_ACTIVIDAD_PREPARADO," +
                                    " pp.TIEMPO_PROCESO_PERSONAL,pp.PORCIENTO_TOLERANCIA_TIEMPO_PROCESO," +
                                    " isnull(sppl.COD_PERSONAL,0) as COD_PERSONAL,isnull(sppl.COD_PERSONAL2,0) as codPersonal2,"+
                                    " isnull(sppl.CONFORME,0) as conforme,isnull(sppl.OBSERVACIONES,'') as OBSERVACIONES" +
                                    " ,ISNULL(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA+' '+p.nombre2_personal,'No Registrado') as operario"+
                                    " ,ISNULL(p2.AP_PATERNO_PERSONAL+' '+p2.AP_MATERNO_PERSONAL+' '+p2.NOMBRE_PILA+' '+p2.nombre2_personal,'No Registrado') as operario2"+
                                    " from PROCESOS_PRODUCTO pp inner join ACTIVIDADES_PREPARADO ap on "+
                                    " ap.COD_ACTIVIDAD_PREPARADO=pp.COD_ACTIVIDAD_PREPARADO "+
                                    "  left outer JOIN maquinarias m on m.COD_MAQUINA=pp.COD_MAQUINA" +
                                    " left outer join SEGUIMIENTO_PROCESOS_PREPARADO_LOTE sppl on sppl.COD_LOTE='"+codLote+"'"+
                                    " and sppl.COD_PROCESO_PRODUCTO=pp.COD_PROCESO_PRODUCTO and sppl.COD_SUB_PROCESO_PRODUCTO='0'" +
                                    " left outer join PERSONAL p on p.COD_PERSONAL=sppl.COD_PERSONAL" +
                                    " left outer join PERSONAL p2 on p2.COD_PERSONAL=sppl.COD_PERSONAL2"+
                                    " where pp.COD_COMPPROD="+codCompProd+" and pp.COD_PROCESO_ORDEN_MANUFACTURA=0 order by pp.NRO_PASO";
                    System.out.println("consulta procesos prod "+consulta);
                    res=st.executeQuery(consulta);
                    String codProceso="";
                    String codSubProceso="";
                    String codProcesoDestino="";
                    int posYcen=10;
                    int posYder=10;
                    int posYizq=10;
                    int posSubProceso=0;
                    Statement std=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet resd=null;
                    String codProcesoProd="";
                    String codSubProcesoProd="";
                    String especificaciones="";
                    String espEquipSubProces="";
                    String nodos="";
                    int cont2=0;
                    int contNodoP=0;
                    int contNodoSubP=0;
                    int nroPasoProceso=0;
                    int nroPasoSubProceso=0;
                    boolean subprocesoDer=true;
                    boolean primerRegistro=false;
                    Statement stdd=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    ResultSet resdd=null;
                    String script="";
                    String scriptUnion="";
                    String materiales="";
                    String materialesSubProceso="";
                    double tiempoProceso=0;
                    double tiempoSubProces=0;
                    String descripcion="";
                    String descripcionSubProces="";
                    String maquinariasDetalles="";
                    String cabecera="";
                    String cabeceraSubProces="";
                    String maquinariasSubProces="";
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat formatoNumero = (DecimalFormat)nf;
                    formatoNumero.applyPattern("###0.0");
                    int operarioTiempoCompletoProcesos=0;
                    int operarioTiempoCompletoSubProceso=0;
                    String variables="";
                    List<String[]> listaPuntos=new ArrayList();
                    String[] puntos=new String[3];
                    puntos[0]="";
                    puntos[1]="";
                    puntos[2]="";
                    String[] subPuntos=new String[3];
                    subPuntos[0]="";
                    subPuntos[1]="";
                    subPuntos[2]="";
                    String codPersonalProceso="0";
                    String codPersonal2Proceso="0";
                    String conforme="0";
                    String observacion="";
                    String operario="";
                    String operario2="";
                    String codPersonalSubProceso="0";
                    String codPersonalSubProceso2="0";
                    String conforme2="0";
                    String observacion2="";
                    String operarioSubProceso="";
                    String operarioSubProceso2="";
                    while(res.next())
                    {
                        cont2++;
                        contNodoP++;
                        operario=res.getString("operario");
                        operario2=res.getString("operario2");
                        codPersonalProceso=res.getString("COD_PERSONAL");
                        codPersonal2Proceso=res.getString("codPersonal2");
                        conforme=(res.getInt("conforme")>0?"1":"0");
                        observacion=res.getString("OBSERVACIONES");
                        codProceso=res.getString("COD_PROCESO_PRODUCTO");
                        operarioTiempoCompletoProcesos=res.getInt("OPERARIO_TIEMPO_COMPLETO");
                        nroPasoProceso=res.getInt("NRO_PASO");
                        codProcesoProd=res.getString("COD_PROCESO_PRODUCTO");
                        tiempoProceso=res.getInt("TIEMPO_PROCESO");
                        descripcion=res.getString("descripcion");
                        especificaciones="";
                        if(!codProcesoDestino.equals(""))
                        {
                            subPuntos[1]="s"+codProcesoDestino;
                            subPuntos[2]="1";
                            listaPuntos.add(subPuntos);
                        }
                        else
                        {
                            if((subPuntos[0].length()>0) && (subPuntos[0].charAt(0)=='p'))
                            {
                                subPuntos[1]="s"+codProcesoProd;
                                subPuntos[2]="2";
                                listaPuntos.add(subPuntos);
                            }
                        }
                        if(!puntos[0].equals(""))
                        {
                            System.out.println("ccccccccc "+codProcesoProd);
                            puntos[1]="s"+codProcesoProd;
                            puntos[2]="";
                            listaPuntos.add(puntos);
                        }

                        subPuntos=new String[3];
                        subPuntos[0]="s"+codProcesoProd;
                        subPuntos[1]="";
                        subPuntos[2]="";
                        puntos=new String[3];
                        puntos[0]="s"+codProcesoProd;
                        puntos[1]="";
                        puntos[2]="";
                        codProcesoDestino="";
                        posYcen=posYizq>posYcen?posYizq:posYcen;
                        posSubProceso=0;
                        consulta="select ppeq.COD_ESPECIFICACION_EQUIPO_AMBIENTE,m.NOMBRE_MAQUINA,m.codigo,isnull(eea.NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE,'') as NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE,"+
                                " ISNULL(case WHEN td.COD_TIPO_DESCRIPCION = 1 THEN (case when ppeq.DATOS_NO_CONSOLIDADOS=0 then ppeq.VALOR_DESCRIPTIVO else '_______________' end )"+
                                " WHEN td.COD_TIPO_DESCRIPCION = 2 THEN (case when ppeq.DATOS_NO_CONSOLIDADOS=0 then CAST (ppeq.RANGO_INFERIOR"+
                                " as varchar) + ' - ' + cast (ppeq.RANGO_SUPERIOR as varchar) else '____-_____' end)"+
                                " else (case when ppeq.DATOS_NO_CONSOLIDADOS=0 then CAST (ppeq.VALOR_EXACTO as varchar)else '_____' end )"+
                                " end, '') as resultado,"+
                                " (case WHEN eea.COD_UNIDAD_MEDIDA>0 THEN um.ABREVIATURA"+
                                " WHEN eea.COD_UNIDAD_TIEMPO>0 THEN ut.ABREVIATURA "+
                                " WHEN eea.COD_UNIDAD_VELOCIDAD >0 then  uv.NOMBRE_UNIDAD_VELOCIDAD" +
                                " when eea.COD_UNIDAD_MEDIDA_TEMPERATURA>0 then umt.ABREVIATURA"+
                                " else '4'  end ) as unidad,ppeq.PORCIENTO_TOLERANCIA,(eea.TOLERANCIA*ppeq.VALOR_EXACTO) AS TOLERANCIA" +
                                " ,eea.TOLERANCIA as toleranciaEspecificacion"+
                                " from PROCESOS_PRODUCTO_MAQUINARIA ppm inner join maquinarias m on "+
                                " m.COD_MAQUINA=ppm.COD_MAQUINA left outer join "+
                                " PROCESOS_PRODUCTO_ESP_EQUIP ppeq on"+
                                " ppm.COD_MAQUINA=ppeq.COD_MAQUINA and ppm.COD_PROCESO_PRODUCTO=ppeq.COD_PROCESO_PRODUCTO and ppeq.COD_FORMULA_MAESTRA='"+(Math.round(prod1[2]))+"'" +
                                " left outer join ESPECIFICACIONES_EQUIPO_AMBIENTE eea on"+
                                " eea.COD_ESPECIFICACION_EQUIPO_AMBIENTE=ppeq.COD_ESPECIFICACION_EQUIPO_AMBIENTE left outer join"+
                                " TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION=eea.COD_TIPO_DESCRIPCION"+
                                " LEFT OUTER JOIN UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=eea.COD_UNIDAD_MEDIDA"+
                                " left outer join UNIDADES_TIEMPO ut on ut.COD_UNIDAD_TIEMPO=eea.COD_UNIDAD_TIEMPO"+
                                " left outer join UNIDADES_VELOCIDAD_MAQUINARIA uv on uv.COD_UNIDAD_VELOCIDAD=eea.COD_UNIDAD_VELOCIDAD" +
                                " left outer join UNIDADES_MEDIDA_TEMPERATURA umt on "+
                                " umt.COD_UNIDAD_MEDIDA_TEMPERATURA=eea.COD_UNIDAD_MEDIDA_TEMPERATURA"+
                                " where ppm.COD_PROCESO_PRODUCTO='"+codProcesoProd+"' order by m.NOMBRE_MAQUINA,m.codigo,NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE";
                        System.out.println("consulta esp "+consulta);
                        resd=std.executeQuery(consulta);
                        int cont=tiempoProceso>0?7:5;
                        cabecera="";
                        maquinariasDetalles="";
                        String nombreMaq="";
                        String resultado="";
                        while(resd.next())
                        {
                            nombreMaq=resd.getString("NOMBRE_MAQUINA")+" "+resd.getString("codigo");
                            cont++;
                           if(!cabecera.equals(nombreMaq))
                           {
                               maquinariasDetalles+= cabecera.equals("")?"":((maquinariasDetalles.equals("")?"":",")+"['"+cabecera+"',["+especificaciones+"]]");
                               cabecera=nombreMaq;
                               especificaciones="";
                           }
                            if(!resd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE").equals(""))
                             {
                                resultado=resd.getString("resultado");
                                double cant=0d;
                                if(resd.getInt("COD_ESPECIFICACION_EQUIPO_AMBIENTE")==10)
                                {
                                    Statement stMat=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    ResultSet resMat=stMat.executeQuery("select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod1[2]))+"'");
                                    System.out.println("consulta cantida fm select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod1[2]))+"'");
                                    
                                    System.out.println("c "+prod1[1]+" d "+prod2[1] );
                                    if(resMat.next())
                                    {
                                        cant=resMat.getDouble("cantMat")*prod1[1];
                                    }
                                    if(loteMix)
                                    {
                                        resMat=stMat.executeQuery("select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod2[2]))+"'");
                                        System.out.println("consulta cantidad fm 2 select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod2[2]))+"'");
                                        if(resMat.next())
                                        {
                                            cant+=(resMat.getDouble("cantMat")*prod2[1]);
                                        }
                                    }
                                    resMat.close();
                                    stMat.close();
                                    resultado=formatoNumero.format(cant);
                                }

                            especificaciones+=((especificaciones.equals("")?"":",")+"'"+resd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE")+"','"+
                                    resultado+" "+resd.getString("unidad")+" "+(resd.getDouble("TOLERANCIA")>0||cant>0?(" ±"+formatoNumero.format((cant>0?(cant*resd.getDouble("toleranciaEspecificacion")):resd.getDouble("TOLERANCIA")))+" "+resd.getString("unidad")):"")+"'");
                            }
                        }
                        maquinariasDetalles+= cabecera.equals("")?"":((maquinariasDetalles.equals("")?"":",")+"['"+cabecera+"',["+especificaciones+"]]");
                        consulta="select m.NOMBRE_MATERIAL,ppem.CANTIDAD,um.ABREVIATURA,fmd.CANTIDAD as cantidadfm," +// as porcenta,ppem.PORCIENTO_MATERIAL,fmd.CANTIDAD
                                " ISNULL(fmd1.CANTIDAD,0) as cantidadSegundoMaterial"+
                                 " from PROCESOS_PRODUCTO_ESP_MAT ppem " +
                                 " inner join MATERIALES m on m.COD_MATERIAL=ppem.COD_MATERIAL"+
                                 " inner join FORMULA_MAESTRA_DETALLE_MP fmd on fmd.COD_MATERIAL=ppem.COD_MATERIAL "+
                                 " and fmd.COD_FORMULA_MAESTRA=ppem.COD_FORMULA_MAESTRA"+
                                 " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA" +
                                 " left outer join FORMULA_MAESTRA_DETALLE_MP fmd1 on"+
                                 " fmd1.COD_MATERIAL=ppem.COD_MATERIAL and fmd1.COD_FORMULA_MAESTRA='"+(loteMix?Math.round(prod2[2]):0)+"'" +
                                 " where ppem.COD_PROCESO_PRODUCTO='"+codProcesoProd+"' and ppem.COD_FORMULA_MAESTRA='"+(loteMix?Math.round(prod2[2]):Math.round(prod1[2]))+"'";
                        consulta="SELECT m.NOMBRE_MATERIAL,um.ABREVIATURA,fmd.cantidad,sum(fmdf.cantidad) as cantidadFraccion,"+
                                 " fmd.CANTIDAD AS cantidadfm,ISNULL(fmd1.CANTIDAD, 0) AS cantidadSegundoMaterial " +
                                 " FROM PROCESOS_PRODUCTO_ESP_MAT ppem INNER JOIN MATERIALES m ON m.COD_MATERIAL = ppem.COD_MATERIAL"+
                                 " INNER JOIN FORMULA_MAESTRA_DETALLE_MP fmd ON fmd.COD_MATERIAL = ppem.COD_MATERIAL"+
                                 " AND fmd.COD_FORMULA_MAESTRA = ppem.COD_FORMULA_MAESTRA"+
                                 " inner join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmdf on fmd.COD_FORMULA_MAESTRA=fmdf.COD_FORMULA_MAESTRA"+
                                 " and fmd.COD_MATERIAL=fmdf.COD_MATERIAL and fmdf.COD_FORMULA_MAESTRA_FRACCIONES=ppem.COD_FORMULA_MAESTRA_FRACCIONES"+
                                 " INNER JOIN UNIDADES_MEDIDA um ON um.COD_UNIDAD_MEDIDA = fmd.COD_UNIDAD_MEDIDA"+
                                 " LEFT OUTER JOIN FORMULA_MAESTRA_DETALLE_MP fmd1 ON fmd1.COD_MATERIAL = ppem.COD_MATERIAL"+
                                 " AND fmd1.COD_FORMULA_MAESTRA = '"+(loteMix?Math.round(prod2[2]):0)+"'"+
                                 " WHERE ppem.COD_PROCESO_PRODUCTO = '"+codProcesoProd+"' AND ppem.COD_FORMULA_MAESTRA = '"+(Math.round(prod1[2]))+"'"+
                                 " group by  m.NOMBRE_MATERIAL,um.ABREVIATURA,fmd.cantidad,fmd.CANTIDAD ,fmd1.CANTIDAD";
                                System.out.println("consulta materiales "+consulta);
                                resd=std.executeQuery(consulta);
                                materiales="";
                                double porciento=0d;
                                while(resd.next())
                                {
                                    cont++;
                                     porciento=(loteMix?(resd.getDouble("cantidadFraccion")/resd.getDouble("cantidadfm")):0);
                                    materiales+=((materiales.equals("")?"":",")+"'"+resd.getString("NOMBRE_MATERIAL")+"','"+
                                            nf.format(loteMix?((resd.getDouble("cantidadFraccion")*prod1[1])+(resd.getDouble("cantidadSegundoMaterial")*prod2[1]*porciento)):(resd.getDouble("cantidadFraccion")*prod1[1]))+
                                            //nf.format((resd.getDouble("CANTIDAD")*resd.getDouble("PORCIENTO_MATERIAL")*prod1[1])+(prod2[2]==null?0:((resd.getDouble("cantidadSegundoMaterial")*resd.getDouble("PORCIENTO_MATERIAL")*prod2[1]))))+
                                            " ("+resd.getString("ABREVIATURA")+")'");
                                }
                        consulta="select spp.COD_PROCESO_PRODUCTO_DESTINO,spp.COD_SUB_PROCESO_PRODUCTO,spp.descripcion,spp.TIEMPO_SUB_PROCESO,spp.COD_SUB_PROCESO_PRODUCTO,ap.NOMBRE_ACTIVIDAD_PREPARADO,spp.NRO_PASO,"+
                                 " spp.TIEMPO_SUB_PROCESO_PERSONAL,spp.PORCIENTO_TOLERANCIA_TIEMPO_SUB_PROCESO,spp.OPERARIO_TIEMPO_COMPLETO" +
                                " ,isnull(sppl.COD_PERSONAL,0) as COD_PERSONAL,isnull(sppl.COD_PERSONAL2,0) as codPersonal2,"+
                                " isnull(sppl.CONFORME,0) as conforme,isnull(sppl.OBSERVACIONES,'') as OBSERVACIONES" +
                                " ,ISNULL(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRE_PILA+' '+p.nombre2_personal,'No Registrado') as operario"+
                                " ,ISNULL(p2.AP_PATERNO_PERSONAL+' '+p2.AP_MATERNO_PERSONAL+' '+p2.NOMBRE_PILA+' '+p2.nombre2_personal,'No Registrado') as operario2"+
                                 " from SUB_PROCESOS_PRODUCTO spp inner join ACTIVIDADES_PREPARADO ap"+
                                 " on spp.COD_ACTIVIDAD_PREPARADO=ap.COD_ACTIVIDAD_PREPARADO"+
                                 " left outer join maquinarias m on m.COD_MAQUINA=spp.COD_MAQUINA"+
                                 " left outer join SEGUIMIENTO_PROCESOS_PREPARADO_LOTE sppl on sppl.COD_PROCESO_PRODUCTO=spp.COD_PROCESO_PRODUCTO"+
                                 " and sppl.COD_SUB_PROCESO_PRODUCTO=spp.COD_SUB_PROCESO_PRODUCTO and sppl.COD_LOTE='"+codLote+"'"+
                                 " left outer join PERSONAL p on p.COD_PERSONAL=sppl.COD_PERSONAL"+
                                 " left outer join PERSONAL p2 on p2.COD_PERSONAL=sppl.COD_PERSONAL2"+
                                 " where spp.COD_PROCESO_PRODUCTO='"+codProcesoProd+"'" +
                                 " order by spp.NRO_PASO";
                        System.out.println("consulta subprocesos "+consulta);
                        resd=std.executeQuery(consulta);
                        contNodoSubP=0;
                        primerRegistro=true;
                        subprocesoDer=true;
                         script+="var s"+codProcesoProd+" = uml.State.create({rect: {x:750, y: "+posYcen+", width: 400, height:"+(cont+3+(descripcion.equals("")?0:6))*18+"},"+
                                "label: '"+nroPasoProceso+"-Actividad:"+res.getString("NOMBRE_ACTIVIDAD_PREPARADO")+( tiempoProceso>0?"-Tiempo:"+tiempoProceso+
                                " min-Tolerancia:"+nf.format((res.getDouble("PORCIENTO_TOLERANCIA_TIEMPO_PROCESO")/100)*tiempoProceso)+" min":"")+" -Operario Tiempo Completo:"+(operarioTiempoCompletoProcesos>0?"SI":"NO")+
                                "',attrs: {fill:'90-#000-"+(operarioTiempoCompletoProcesos>0?"#87CEFA":"#FFC0CB")+":1-#fff'}," +
                                (materiales.equals("")?"":"materiales:["+materiales+"],")+
                                (maquinariasDetalles.equals("")?"":("datosMaq:["+maquinariasDetalles+"],"))+
                                "actions:{actividad:null," +
                                "Maquinaria:'ninguno'"+
                                (especificaciones.equals("")?"":",inner: ["+especificaciones+"]") +
                                "},descripcion:'"+descripcion.replace(b, '-').replace(c,' ')+"'" +
                                ",detailsOffsetY:"+(tiempoProceso>0?"5":"3")+",codProcesos:'"+codProceso+"',codSubProceso:'0'" +
                                ",operario:'"+operario+"',operario2:'"+operario2+"',codPersonal:'"+codPersonalProceso+"',codPersonal2:'"+codPersonal2Proceso+"'" +
                                ",conforme:'"+conforme+"',observaciones:'"+observacion+"'});";

                        variables+=(variables.equals("")?"":",")+"s"+codProcesoProd;
                        posYcen+=((cont+3+(descripcion.equals("")?0:6))*17)+50;
                        while(resd.next())
                            {
                                cont2++;
                                operarioSubProceso=resd.getString("operario");
                                operarioSubProceso2=resd.getString("operario2");
                                codPersonalSubProceso=resd.getString("COD_PERSONAL");
                                codPersonalSubProceso2=resd.getString("codPersonal2");
                                conforme2=(resd.getInt("conforme")>0?"1":"0");
                                observacion2=resd.getString("OBSERVACIONES");
                                codProcesoDestino=(resd.getInt("COD_PROCESO_PRODUCTO_DESTINO")>0?resd.getString("COD_PROCESO_PRODUCTO_DESTINO"):"");
                                codSubProceso=resd.getString("COD_SUB_PROCESO_PRODUCTO");
                                operarioTiempoCompletoSubProceso=resd.getInt("OPERARIO_TIEMPO_COMPLETO");
                                descripcionSubProces=resd.getString("descripcion");
                                tiempoSubProces=resd.getDouble("TIEMPO_SUB_PROCESO");
                                nroPasoSubProceso=resd.getInt("NRO_PASO");
                                codSubProcesoProd=resd.getString("COD_SUB_PROCESO_PRODUCTO");
                                subPuntos[1]="p"+codProcesoProd+"s"+codSubProceso;
                                if(subPuntos[0].charAt(0)=='s')
                                {
                                    subPuntos[2]="5";
                                }
                                listaPuntos.add(subPuntos);
                                subPuntos=new String[3];
                                subPuntos[0]="p"+codProcesoProd+"s"+codSubProceso;
                                subPuntos[1]="";
                                subPuntos[2]="";
                                espEquipSubProces="";
                                if(primerRegistro)
                                {
                                    subprocesoDer=!subprocesoDer;
                                    posYcen=(subprocesoDer?(posYder>posYcen?posYder+12:posYcen):(posYizq>posYcen?posYizq+12:posYcen));
                                    posYizq=(subprocesoDer?posYizq:(posYcen>posYizq?posYcen:posYizq));
                                    posYder=(subprocesoDer?(posYcen>posYder?posYcen:posYder):posYder);

                                }
                                contNodoSubP++;
                                consulta="select sppeq.COD_ESPECIFICACION_EQUIPO_AMBIENTE,m.NOMBRE_MAQUINA,ISNULL(m.CODIGO,'') as cod1,isnull(eea.NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE,'') as NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE," +
                                        " ISNULL(case WHEN td.COD_TIPO_DESCRIPCION = 1 THEN (case when sppeq.DATOS_NO_CONSOLIDADOS=0 then sppeq.VALOR_DESCRIPTIVO else '__________' end)"+
                                        " WHEN td.COD_TIPO_DESCRIPCION = 2 THEN (case when sppeq.DATOS_NO_CONSOLIDADOS=0 then (CAST ("+
                                        " sppeq.RANGO_INFERIOR as varchar) + ' - ' + cast ( sppeq.RANGO_SUPERIOR as varchar)) ELSE '___-___' end )"+
                                        " else  (case when sppeq.DATOS_NO_CONSOLIDADOS=0 then CAST (sppeq.VALOR_EXACTO as varchar)else '___' end )"+
                                        " end, '') as resultado,"+
                                         " (case WHEN eea.COD_UNIDAD_MEDIDA > 0 THEN um.ABREVIATURA WHEN eea.COD_UNIDAD_TIEMPO > 0 THEN ut.ABREVIATURA"+
                                         " WHEN eea.COD_UNIDAD_VELOCIDAD > 0 then uv.NOMBRE_UNIDAD_VELOCIDAD " +
                                         " WHEN eea.COD_UNIDAD_MEDIDA_TEMPERATURA>0 then umt.ABREVIATURA else ' ' end) as unidad," +
                                         " (eea.TOLERANCIA*sppeq.VALOR_EXACTO) AS tolerancia"+
                                         " from SUB_PROCESOS_PRODUCTO_MAQUINARIA sppm inner join maquinarias m on"+
                                         " sppm.COD_MAQUINA=m.COD_MAQUINA left outer join SUB_PROCESOS_PRODUCTO_ESP_EQUIP sppeq " +
                                         " on sppeq.COD_MAQUINA=sppm.COD_MAQUINA and sppeq.COD_SUB_PROCESO_PRODUCTO=sppm.COD_SUB_PROCESO_PRODUCTO"+
                                         " and sppeq.COD_PROCESO_PRODUCTO=sppm.COD_PROCESO_PRODUCTO and sppeq.COD_FORMULA_MAESTRA='"+(Math.round(prod1[2]))+"'" +
                                         " left outer join ESPECIFICACIONES_EQUIPO_AMBIENTE eea"+
                                         " on eea.COD_ESPECIFICACION_EQUIPO_AMBIENTE=sppeq.COD_ESPECIFICACION_EQUIPO_AMBIENTE"+
                                         " left outer join TIPOS_DESCRIPCION td on td.COD_TIPO_DESCRIPCION =eea.COD_TIPO_DESCRIPCION"+
                                         " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=eea.COD_UNIDAD_MEDIDA" +
                                         " left outer join UNIDADES_TIEMPO ut on ut.COD_UNIDAD_TIEMPO=eea.COD_UNIDAD_TIEMPO"+
                                         " left outer join UNIDADES_VELOCIDAD_MAQUINARIA uv on uv.COD_UNIDAD_VELOCIDAD=eea.COD_UNIDAD_VELOCIDAD" +
                                         " left outer join UNIDADES_MEDIDA_TEMPERATURA umt on umt.COD_UNIDAD_MEDIDA_TEMPERATURA=eea.COD_UNIDAD_MEDIDA_TEMPERATURA"+
                                         " where sppm.COD_PROCESO_PRODUCTO='"+codProcesoProd+"'  and sppm.COD_SUB_PROCESO_PRODUCTO='"+codSubProcesoProd+"'"+
                                         " order by m.NOMBRE_MAQUINA,eea.NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE";
                                        System.out.println("consulta buscar det esp equip"+consulta);
                                         resdd=stdd.executeQuery(consulta);

                                         int contSubproces=tiempoSubProces>0?7:5;
                                         cabeceraSubProces="";
                                         maquinariasSubProces="";
                                         String maqSubProcess="";
                                         espEquipSubProces="";
                                         while(resdd.next())
                                         {
                                             maqSubProcess=resdd.getString("NOMBRE_MAQUINA")+" "+resdd.getString("cod1");
                                             if(!cabeceraSubProces.equals(maqSubProcess))
                                               {
                                                   maquinariasSubProces+=cabeceraSubProces.equals("")?"":((maquinariasSubProces.equals("")?"":",")+"['"+cabeceraSubProces+"',["+espEquipSubProces+"]]");
                                                   cabeceraSubProces=maqSubProcess;
                                                   espEquipSubProces="";
                                                   contSubproces++;
                                               }
                                             if(!resdd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE").equals(""))
                                             {
                                                 String resultado2=resdd.getString("resultado");
                                                 if(resdd.getInt("COD_ESPECIFICACION_EQUIPO_AMBIENTE")==10)
                                                    {
                                                        Statement stMat=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                        ResultSet resMat=stMat.executeQuery("select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod1[2]))+"'");
                                                        System.out.println("consulta cantida fm select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod1[2]))+"'");
                                                        double cant=0d;
                                                        System.out.println("c "+prod1[1]+" d "+prod2[1] );
                                                        if(resMat.next())
                                                        {
                                                            cant=(loteMix?(resMat.getDouble("cantMat")*prod1[1]):resMat.getDouble("cantMat"));
                                                        }
                                                        if(loteMix)
                                                        {
                                                            resMat=stMat.executeQuery("select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod2[2]))+"'");
                                                            System.out.println("consulta cantidad fm 2 select SUM(fd.CANTIDAD/(case when fd.COD_UNIDAD_MEDIDA = 7 then 1000 else 1 end)) as cantMat from FORMULA_MAESTRA_DETALLE_MP fd where fd.COD_FORMULA_MAESTRA ='"+(Math.round(prod2[2]))+"'");
                                                            if(resMat.next())
                                                            {
                                                                cant+=(resMat.getDouble("cantMat")*prod2[1]);
                                                            }
                                                        }
                                                        resMat.close();
                                                        stMat.close();
                                                        resultado2=formatoNumero.format(cant);
                                                    }
                                                 contSubproces++;
                                                 espEquipSubProces+=((espEquipSubProces.equals("")?"":",")+"'"+resdd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE")+"','"+
                                                    resultado2+" "+resdd.getString("unidad")+(resdd.getDouble("tolerancia")>0?(" ±"+formatoNumero.format(resdd.getDouble("tolerancia"))+" "+resdd.getString("unidad") ):"")+"'");
                                             }
                                         }
                                         maquinariasSubProces+=cabeceraSubProces.equals("")?"":((maquinariasSubProces.equals("")?"":",")+"['"+cabeceraSubProces+"',["+espEquipSubProces+"]]");
                                         cabeceraSubProces=maqSubProcess;

                                consulta="SELECT m.NOMBRE_MATERIAL,sppem.CANTIDAD ,fmd.CANTIDAD as cantidadFm,um.ABREVIATURA" +
                                        ",ISNULL(fmdsub.CANTIDAD,0) as cantidadCompprod2"+
                                         " FROM SUB_PROCESOS_PRODUCTO_ESP_MAT sppem inner join MATERIALES m"+
                                         " on m.COD_MATERIAL=sppem.COD_MATERIAL inner join FORMULA_MAESTRA_DETALLE_MP"+
                                         " fmd on fmd.COD_FORMULA_MAESTRA=sppem.COD_FORMULA_MAESTRA and"+
                                         " fmd.COD_MATERIAL=sppem.COD_MATERIAL"+
                                         " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA" +
                                         " left outer join FORMULA_MAESTRA_DETALLE_MP fmdsub on fmdsub.COD_MATERIAL=sppem.COD_MATERIAL and fmdsub.COD_FORMULA_MAESTRA='"+(loteMix?Math.round(prod2[2]):0)+"'"+
                                         " where  sppem.COD_SUB_PROCESO_PRODUCTO='"+codSubProcesoProd+"'"+
                                         " and sppem.COD_PROCESO_PRODUCTO='"+codProcesoProd+"' and sppem.COD_FORMULA_MAESTRA='"+(loteMix?Math.round(prod2[2]):Math.round(prod1[2]))+"'";
                                 consulta="SELECT m.NOMBRE_MATERIAL,fmd.CANTIDAD AS cantidadFm, um.ABREVIATURA, sum(fmdf.CANTIDAD) as cantidadFracciones,"+
                                         " ISNULL(fmdsub.CANTIDAD, 0) AS cantidadCompprod2 " +
                                         " FROM SUB_PROCESOS_PRODUCTO_ESP_MAT sppem INNER JOIN MATERIALES m ON m.COD_MATERIAL = sppem.COD_MATERIAL"+
                                         " INNER JOIN FORMULA_MAESTRA_DETALLE_MP fmd ON fmd.COD_FORMULA_MAESTRA = sppem.COD_FORMULA_MAESTRA"+
                                         " AND fmd.COD_MATERIAL = sppem.COD_MATERIAL"+
                                         " inner join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmdf on fmdf.COD_FORMULA_MAESTRA=fmd.COD_FORMULA_MAESTRA"+
                                         " and m.COD_MATERIAL=fmdf.COD_MATERIAL and fmdf.COD_FORMULA_MAESTRA_FRACCIONES=sppem.COD_FORMULA_MAESTRA_FRACCIONES"+
                                         " INNER JOIN UNIDADES_MEDIDA um ON um.COD_UNIDAD_MEDIDA = fmd.COD_UNIDAD_MEDIDA"+
                                         " LEFT OUTER JOIN FORMULA_MAESTRA_DETALLE_MP fmdsub ON fmdsub.COD_MATERIAL = sppem.COD_MATERIAL"+
                                         " AND fmdsub.COD_FORMULA_MAESTRA = '"+(loteMix?Math.round(prod2[2]):0)+"'"+
                                         " WHERE sppem.COD_SUB_PROCESO_PRODUCTO = '"+codSubProcesoProd+"' AND sppem.COD_PROCESO_PRODUCTO = '"+codProcesoProd+"'"+
                                         " AND sppem.COD_FORMULA_MAESTRA = '"+(Math.round(prod1[2]))+"' group by m.NOMBRE_MATERIAL,fmd.CANTIDAD ,um.ABREVIATURA,fmdsub.CANTIDAD";
                                System.out.println("consulta materiales sub"+consulta);
                                 resdd=stdd.executeQuery(consulta);
                                materialesSubProceso="";
                                 while(resdd.next())
                                 {
                                     contSubproces++;
                                     porciento=(loteMix?(resdd.getDouble("cantidadFracciones")/resdd.getDouble("cantidadFm")):0);
                                     materialesSubProceso+=((materialesSubProceso.equals("")?"":",")+"'"+resdd.getString("NOMBRE_MATERIAL")+"','"+
                                             nf.format(loteMix?((resdd.getDouble("cantidadFracciones")*prod1[1])+(resdd.getDouble("cantidadCompprod2")*prod2[1]*porciento)):(resdd.getDouble("cantidadFracciones")*prod1[1]))+
                                        //nf.format((resdd.getDouble("CANTIDAD")*resdd.getDouble("PORCIENTO_MATERIAL")*prod1[1])+(prod2[2]==null?0:((resdd.getDouble("cantidadCompprod2")*resdd.getDouble("PORCIENTO_MATERIAL")*prod2[1]))))+
                                        " ("+resdd.getString("ABREVIATURA")+")'");
                                 }

                                script+="var p"+codProcesoProd+"s"+codSubProceso+"= uml.State.create({rect: {x:250, y: "+(subprocesoDer?posYder:posYizq)+", width: 400, height:"+(contSubproces+3+(descripcionSubProces.equals("")?0:6))*18+"},"+
                                        "label: '"+nroPasoProceso+"."+nroPasoSubProceso+" -Actividad:"+resd.getString("NOMBRE_ACTIVIDAD_PREPARADO")+(tiempoSubProces>0?" -Tiempo :"+tiempoSubProces+" " +
                                        "min-Tolerancia:"+nf.format((resd.getDouble("PORCIENTO_TOLERANCIA_TIEMPO_SUB_PROCESO")/100)*tiempoSubProces)+" min ":"")+"-Operario Tiempo Completo:"+(operarioTiempoCompletoSubProceso>0?"SI":"NO")+
                                        "',attrs: {fill:'90-#000-"+(operarioTiempoCompletoSubProceso>0?"#90EE90":"#FFC0CB")+":1-#fff'}," +
                                        (materialesSubProceso.equals("")?"":"materiales:["+materialesSubProceso+"],")+
                                        (maquinariasSubProces.equals("")?"":("datosMaq:["+maquinariasSubProces+"],"))+
                                        //(descripcionSubProces.equals("")?"":"descripcion:'"+descripcionSubProces.replace(b, '&').replace(c,' ')+"',")+
                                        "actions:{actividad:null," +
                                        "Maquinaria:'ninguno'"+
                                        (espEquipSubProces.equals("")?"":",inner: ["+espEquipSubProces+"]") +
                                        "},descripcion:'"+descripcionSubProces.replace(b, '-').replace(c,' ')+"'" +
                                        ",detailsOffsetY:"+(tiempoSubProces>0?"5":"3")+",codProcesos:'"+codProceso+"',codSubProceso:'"+codSubProceso+"'," +
                                        "operario:'"+operarioSubProceso+"',operario2:'"+operarioSubProceso2+"',codPersonal:'"+codPersonalSubProceso+"',codPersonal2:'"+codPersonalSubProceso2+"'" +
                                        ",conforme:'"+conforme2+"',observaciones:'"+observacion2+"'});";

                                variables+=(variables.equals("")?"":",")+"p"+codProcesoProd+"s"+codSubProceso;
                                posYizq+=(subprocesoDer?0:((contSubproces+3+(descripcionSubProces.equals("")?0:6))*18)+21);
                                posYder+=(subprocesoDer?((contSubproces+3+(descripcionSubProces.equals("")?0:6))*18)+21:0);
                                primerRegistro=false;

                           }
                    }
                    String areglo="";
                    String arrow="";
                    int cont=0;
                    for(String[] var:listaPuntos)
                    {
                        areglo+=(areglo.equals("")?"":",")+var[0]+","+var[1];
                        arrow+=" var m"+cont+"="+var[0]+".joint("+var[1]+", uml.arrow).register(all);";
                        if(var[2].equals("1"))
                        {
                        arrow+="asignarPuntos(m"+cont+");";
                        }
                        if(var[2].equals("2"))
                        {
                        arrow+="crunch(m"+cont+");";
                        }
                        if(var[2].equals("5"))
                        {
                        arrow+="crunch2(m"+cont+");";
                        }
                        arrow+="verificarInterupcion(m"+cont+");";
                        cont++;
                    }
                    scriptUnion+="var all = ["+areglo+"];";

                   out.println("var nccc");
                    scriptUnion+=arrow;
                    
                   // System.out.println(script);
                    int height=posYcen;
                    height=height>posYder?height:posYder;
                    height=height>posYizq?height:posYizq;
                    System.out.println("cdcdcd "+height);
                    out.println(" var paper = Joint.paper('diagrama', 1000, "+ (height+(cont2*110))+");"+script+scriptUnion);
                    
               consulta="select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                         " from personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL"+
                         " where pa.cod_area_empresa in (82) AND p.COD_ESTADO_PERSONA = 1 " +
                         " union select P.COD_PERSONAL,"+
                         " (P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                         " from personal p where p.cod_area_empresa in (82) and p.COD_ESTADO_PERSONA = 1"+
                         " GROUP BY P.COD_PERSONAL,P.AP_MATERNO_PERSONAL,P.AP_PATERNO_PERSONAL,P.NOMBRES_PERSONAL,P.nombre2_personal"+
                         " order by NOMBRES_PERSONAL ";
                System.out.println("consula personal "+consulta);
                String personalSelect="";
                res=st.executeQuery(consulta);
                String operarios="";
                while(res.next())
                {
                    personalSelect+=(personalSelect.equals("")?"":",")+res.getString("COD_PERSONAL")+",'"+res.getString("NOMBRES_PERSONAL")+"'";
                    operarios+="<option value='"+res.getInt("COD_PERSONAL")+"'>"+res.getString("NOMBRES_PERSONAL")+"</option>";
                }
                out.println("personalSelect=new Array("+personalSelect+");codLote='"+codLote+"';");
               /* consulta="select s.COD_PROCESO_PRODUCTO,s.COD_SUB_PROCESO_PRODUCTO,pp.COD_PERSONAL,(pp.AP_PATERNO_PERSONAL+' '+pp.AP_MATERNO_PERSONAL+' '+pp.NOMBRE_PILA)as nombre,s.CONFORME" +
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
                /*for(String var1:variables)
                {
                    out.println(var1+".asignarOperario(new Array("+codP+"));");
                  
                }*/
                //System.out.println("cod "+personalSelect);
               
            %>

       </script>
</div>
<section class="main">
<div class="row"  style="margin-top:5px" >
        <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                    <div class="row">
                       <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                               <label  class="inline">TIEMPO DE PERSONAL</label>
                        </div>
                    </div>
                    <div class="row" >
                        <div  class="divContentClass large-12 medium-12 small-12 columns">
                            <center>
                            <table>
                            <%
                            System.out.println("iniciando verificacion lote");
                            if(loteMix)
                            {
                                System.out.println("lote mix");
                                if(Math.round(prod1[3])==1||Math.round(prod2[3])==1)
                                {
                                    codCompProd=String.valueOf(Math.round(prod1[3]==1?prod1[0]:prod2[0]));
                                    codFormulaMaestra=String .valueOf(Math.round(prod1[3]==1?prod1[2]:prod2[2]));
                                    codTipoProgramaProd="1";
                                }
                                else
                                {
                                    if(Math.round(prod1[3])==3||Math.round(prod2[3])==3)
                                    {
                                        codCompProd=String.valueOf(Math.round(prod1[3]==3?prod1[0]:prod2[0]));
                                        codFormulaMaestra=String .valueOf(Math.round(prod1[3]==3?prod1[2]:prod2[2]));
                                        codTipoProgramaProd="3";
                                    }
                                    else
                                    {
                                        codCompProd=String.valueOf(Math.round(prod1[3]==2?prod1[0]:prod2[0]));
                                        codFormulaMaestra=String .valueOf(Math.round(prod1[3]==2?prod1[2]:prod2[2]));
                                        codTipoProgramaProd="2";
                                    }
                                    
                                }
                            }
                            else
                            {
                                System.out.println("lote normal");
                                codCompProd=String.valueOf(Math.round(prod1[0]));
                                codFormulaMaestra=String .valueOf(Math.round(prod1[2]));
                                codTipoProgramaProd=String.valueOf(Math.round(prod1[3]));
                            }
                            int codActividadPrograma=0;
                              SimpleDateFormat sdfDia=new SimpleDateFormat("dd/MM/yyyy");
                                SimpleDateFormat sdfHora=new SimpleDateFormat("HH:mm");
                            consulta="select af.COD_ACTIVIDAD_FORMULA,spp.COD_MAQUINA,spp.HORAS_MAQUINA"+
                                         " from ACTIVIDADES_FORMULA_MAESTRA af"+
                                         " left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION spp on"+
                                         " spp.COD_ACTIVIDAD_PROGRAMA = af.COD_ACTIVIDAD_FORMULA and"+
                                        " spp.COD_LOTE_PRODUCCION = '"+codLote+"' and spp.COD_PROGRAMA_PROD = '"+codProgramaProd+"' and"+
                                        "  spp.COD_FORMULA_MAESTRA = af.COD_FORMULA_MAESTRA and spp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' and spp.COD_COMPPROD='"+codCompProd+"'"+
                                        " where af.COD_ACTIVIDAD = 71  and af.COD_AREA_EMPRESA=96 and af.cod_presentacion=0"+
                                        " and af.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'";
                            System.out.println("consulta cabecera "+consulta);

                            res=st.executeQuery(consulta);
                            String maquinariasSelect="<option value='0'>--Ninguno--</option>";
                            out.println("<input type='hidden' value='0/0' id='standar0'/>");
                            if(res.next())
                            {
                                codActividadPrograma=res.getInt("COD_ACTIVIDAD_FORMULA");
                                consulta="select  m.COD_MAQUINA,maf.HORAS_HOMBRE,maf.HORAS_MAQUINA,(m.NOMBRE_MAQUINA+' ('+m.CODIGO+')') as NOMBRE_MAQUINA"+
                                       " from maquinarias m inner join MAQUINARIA_ACTIVIDADES_FORMULA maf on m.COD_MAQUINA=maf.COD_MAQUINA"+
                                       " where maf.COD_ACTIVIDAD_FORMULA='"+codActividadPrograma+"' ";
                                       System.out.println("consulta maquinarias "+consulta);
                                 resd=std.executeQuery(consulta);
                                 String horaStandar="0/0";
                                 while(resd.next())
                                   {
                                     if(resd.getInt("COD_MAQUINA")==res.getInt("COD_MAQUINA")){horaStandar=resd.getDouble("HORAS_HOMBRE")+"/"+resd.getDouble("HORAS_MAQUINA");}

                                       maquinariasSelect+="<option value='"+resd.getInt("COD_MAQUINA")+"'>"+resd.getString("NOMBRE_MAQUINA")+"</option>";
                                       out.println("<input id='standar"+resd.getInt("COD_MAQUINA")+"' type='hidden' value='"+resd.getDouble("HORAS_HOMBRE")+"/"+resd.getDouble("HORAS_MAQUINA")+"'/>");
                                   }
                                 
                                 out.println("<tr >" +
                                         "<td><span>Maquinaria:</span></td><td><select id='codMaquinaActividad' onchange='asignarHorasEstandar();'>"+maquinariasSelect+"</select><script>codMaquinaActividad.value='"+res.getInt("COD_MAQUINA")+"';</script></td>" +
                                         "<td><span>Horas Maquina:</span></td>" +
                                         "<td><input id='horasMaquinaActividad' style='width:6em' type='text' value='"+res.getDouble("HORAS_MAQUINA")+"' /></td>" +
                                         "<td><span>Horas Hombre Standar:</span></td>" +
                                         "<td><span id='horasHobreStandard'>"+horaStandar.split("/")[0]+"</span></td>" +
                                         "<td><span>Horas Maquina Standar:</span></td>" +
                                         "<td><span id='horasMaquinaStandard'>"+horaStandar.split("/")[1]+"</span></td>" +
                                         "</tr>");
                            }
                            if(codActividadPrograma==0)
                            {
                                out.println("<script>alert('No se encuentra asociada la actividad de preparado');window.close();</script>");
                            }
                              
                           res=st.executeQuery(consulta);
                           
                           

                                
                            %>
                            </table>
                            <input type="hidden" value="<%=(codTipoProgramaProd)%>" id="codTipoProduccion"/>
                            <input type="hidden" value="<%=(codActividadPrograma)%>" id="codActividadPrograma"/>
                            <input type="hidden" value="<%=(codCompProd)%>" id="codCompProd"/>
                            <input type="hidden" value="<%=(codFormulaMaestra)%>" id="codFormula"/>
                            <input type="hidden" value="<%=(codProgramaProd)%>" id="codProgramaProd"/>
                            <input type="hidden" value="<%=(codLote)%>" id="codLoteProduccion"/>
                            <input type="hidden" value="<%=(sdfDia.format(new Date()))%>" id="fechaSistema"/>
                            <input type="hidden" value="<%=(codPersonalSupervisor)%>" id="cerrado">
                            </center>
                            <table style="width:100%;margin-top:8px" id="registroTiempo" cellpadding="0px" cellspacing="0px">
                                   <tr >
                                       <td class="tableHeaderClass"  style="text-align:center">
                                           <span class="textHeaderClass">Personal</span>
                                       </td>
                                       <td class="tableHeaderClass"  style="text-align:center;">
                                           <span class="textHeaderClass">Fecha</span>
                                       </td>
                                       <td class="tableHeaderClass" style="text-align:center">
                                           <span class="textHeaderClass">Hora Inicio</span>
                                       </td>
                                       <td class="tableHeaderClass" style="text-align:center">
                                           <span class="textHeaderClass">Hora Final</span>
                                       </td>
                                        <td class="tableHeaderClass" style="text-align:center">
                                           <span class="textHeaderClass">Horas Hombre</span>
                                       </td>
                                       
                                   </tr>
                           <%
                                consulta="select P.COD_PERSONAL,(P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                         " from personal P inner join PERSONAL_AREA_PRODUCCION pa on pa.COD_PERSONAL = p.COD_PERSONAL"+
                                         " where pa.cod_area_empresa in (82) AND p.COD_ESTADO_PERSONA = 1 " +
                                         " union select P.COD_PERSONAL,"+
                                         " (P.AP_PATERNO_PERSONAL + ' ' + P.AP_MATERNO_PERSONAL + ' ' +P.NOMBRES_PERSONAL + ' ' + P.nombre2_personal) NOMBRES_PERSONAL"+
                                         " from personal p where p.cod_area_empresa in (82) and p.COD_ESTADO_PERSONA = 1"+
                                         " GROUP BY P.COD_PERSONAL,P.AP_MATERNO_PERSONAL,P.AP_PATERNO_PERSONAL,P.NOMBRES_PERSONAL,P.nombre2_personal"+
                                         " order by NOMBRES_PERSONAL ";
                                System.out.println("consula personal "+consulta);
                                res=st.executeQuery(consulta);
                                operarios="";
                                while(res.next())
                                {
                                    operarios+="<option value='"+res.getInt(1)+"'>"+res.getString(2)+"</option>";
                                }
                                out.println("<script>operariosRegistroGeneral=\""+operarios+"\";" +
                                            "fechaSistemaGeneral='"+sdfDias.format(new Date())+"';" +
                                            "codEstadoHoraRegistro='"+codEstadoHoja+"';</script>");
                         
                                consulta=" select sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE,sppp.REGISTRO_CERRADO"+
                                         " from  SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp where"+
                                         " sppp.COD_LOTE_PRODUCCION = '"+codLote+"' and sppp.COD_PROGRAMA_PROD = '"+codProgramaProd+"' and"+
                                         " sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_COMPPROD='"+codCompProd+"'"+
                                         " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'"+
                                         " and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadPrograma+"'" +
                                         (administrador?"":"and sppp.COD_PERSONAL='"+codPersonal+"'")+
                                         " order by sppp.FECHA_INICIO";
                                System.out.println("consulta cargar seguimiento "+consulta);
                                res=st.executeQuery(consulta);
                              
                                while(res.next())
                                {
                                    //System.out.println("fehca  "+sdfHora.format(res.getTimestamp("FECHA_INICIO")));
                                    out.println("<tr onclick='seleccionarFila(this)' ><td class='tableCell' style='text-align:left'>"+
                                                " <select  "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" id='codPersonalDoc"+res.getRow()+"'>"+(operarios)+"</select><script>codPersonalDoc"+res.getRow()+".value='"+res.getString("COD_PERSONAL")+"'</script></td>"+
                                                " <td class='tableCell' align='center'>"+
                                                (codEstadoHoja==3?"<input "+(administrador?(res.getString("COD_PERSONAL").equals(codPersonal)?"":"disabled"):"")+" id='fechaDoc"+res.getRow()+"' type='tel' onclick='seleccionarDatePickerJs(this);' value='"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"'/>":
                                                "<span class='textHeaderClassBodyNormal'>"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"</span>")+
                                                "</td>" +
                                                " <td class='tableCell' style='text-align:center;width:6em;'><span class='textHeaderClassBodyNormal'>"+sdfHora.format(res.getTimestamp("FECHA_INICIO"))+"</span></td>" +
                                                " <td class='tableCell' style='text-align:center;width:6em;'>" +
                                                " <button "+(administrador?"disabled":"")+" class='"+(res.getInt("REGISTRO_CERRADO")>0?"buttonFinishActive":"buttonFinish")+"' onclick=\"calcularHorasGeneral(this,'"+sdfHora.format(res.getTimestamp("FECHA_INICIO"))+"')\">Terminar</button>"+
                                                " <span class='textHeaderClassBodyNormal' >"+sdfHora.format(res.getTimestamp("FECHA_FINAL"))+"</span>" +
                                                " </td>" +
                                                " <td class='tableCell' style='text-align:center;width:6em;' aling='center'><span class='textHeaderClassBody' style='font-weight:normal'>"+res.getDouble("HORAS_HOMBRE")+"</span></td>" +
                                                "</tr>");
                                    
                                }
                                
                           %>
                           </table>
                           <div class="row">
                               <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                              <div class="large-1 medium-1 small-2 columns">
                                    <button class="small button succes radius buttonAction" onclick="nuevoRegistroGeneral('registroTiempo')">+</button>
                              </div>
                              <div class="large-1 medium-1 small-2 columns">
                                        <button class="small button succes radius buttonAction" onclick="eliminarRegistroTabla('registroTiempo');">-</button>
                              </div>
                              <div class="large-5 medium-5 small-4 columns" style="">&nbsp;</div>
                           </div>
                           <%
                        if(administrador)
                        {
                            consulta="select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal)"+
                                     " from PERSONAL p where p.COD_PERSONAL='"+codPersonal+"'";
                            res=st.executeQuery(consulta);
                            String nombreUsuario="";
                            if(res.next())
                            {
                                nombreUsuario=res.getString(1);
                            }
                        %>
                        <center>
                            <table style="width:80%;margin-top:2px;border-bottom:solid #a80077 1px;" id="datosAdicionales" cellpadding="0px" cellspacing="0px" >
                                <tr >
                                       <td class="tableHeaderClass" style="text-align:center" colspan="3">
                                           <span class="textHeaderClass">APROBACION</span>
                                       </td>
                                </tr>
                                <tr >
                                        <td style="border-left:solid #a80077 1px;text-align:left">
                                           <span >JEFE DE AREA:</span>
                                       </td>
                                        <td style="border-right:solid #a80077 1px;text-align:left">
                                           <input type="hidden" id="codPersonalSupervisor" value="<%=(codPersonalSupervisor)%>"/>
                                           <span><%=(nombreUsuario)%></span>
                                       </td>

                                </tr>
                                <tr >
                                        <td style="border-left:solid #a80077 1px;text-align:left">
                                           <span >Fecha:</span>
                                       </td>
                                        <td style="border-right:solid #a80077 1px;text-align:left">
                                            <span><%=(sdfDias.format(fechaCierre)) %></span>
                                       </td>

                                </tr>
                                <tr >
                                        <td style="border-left:solid #a80077 1px;text-align:left">
                                           <span >Hora:</span>
                                       </td>
                                        <td style="border-right:solid #a80077 1px;text-align:left">
                                            <span><%=(sdfHora.format(fechaCierre)) %></span>
                                       </td>

                                </tr>
                                <tr>
                                        <td class="" style="border-left:solid #a80077 1px;text-align:left">
                                           <span >Observacion</span>
                                       </td>

                                        <td class="" style="border-right:solid #a80077 1px;text-align:left">
                                            <input type="text" id="observacion" value="<%=(observaciones)%>"/>
                                       </td>
                                </tr>
                            </table>
                            </center>
                        <%
                            }
                            res.close();
                            st.close();
                            std.close();
                            con.close();

                        }
                        catch(SQLException ex)
                        {
                            ex.printStackTrace();
                        }
                        %>
                             <div class="row" style="margin-top:0px;">
                                        <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
                                            <div class="row">
                                                <div class="large-6 medium-6 small-12 columns">
                                                    <button class="small button succes radius buttonAction" onclick="guardarSeguimientoProgramaProduccionComprimidos(admin,codPersonal);" >Guardar Seguimiento</button>
                                                </div>
                                                    <div class="large-6 medium-6 small-12  columns">
                                                        <button class="small button succes radius buttonAction" onclick="window.close();" >Cancelar</button>

                                                    </div>
                                            </div>
                                        </div>
                                </div>


                        </div>
                        
                </div>
        </div>
</div>
</section>
    </body>
    
    <script src="../reponse/js/timePickerJs.js"></script>
    <script src="../reponse/js/dataPickerJs.js"></script>
    <script src="../reponse/js/despejeLinea.js"></script>
    <script>
            despejeLinea.verificarDespejeLinea('<%=(codPersonalApruebaDespeje)%>', admin,'codProgramaProd','codLoteProduccion',5,<%=(codPersonal)%>);
            iniciarDatePicker('<%=(sdfDias.format(new Date()))%>');
            loginHoja.verificarHojaCerrada('cerrado', admin,'codProgramaProd','codLoteProduccion',5,<%=(codEstadoHoja)%>);
    </script>
</html>
