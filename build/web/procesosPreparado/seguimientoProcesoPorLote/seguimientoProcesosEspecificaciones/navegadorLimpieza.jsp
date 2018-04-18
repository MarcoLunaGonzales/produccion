7<%@page contentType="text/html"%>
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

<script src="libJs/scripts.js"></script>
<link rel="STYLESHEET" type="text/css" href="../../../css/ventas.css" />
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
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat formatoNumero = (DecimalFormat)nf;
        formatoNumero.applyPattern("###0");
        String codProgramaProd=request.getParameter("codProgProd");
        char b=13;char c=10;
        %>
<div id="principal">
        <center>
             



            <table width="80%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="0" cellspacing="0" >
                 <%
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
                                    " ,cp.PESO_ENVASE_PRIMARIO,tpp.ABREVIATURA as abtp,(cast (cp.CANTIDAD_VOLUMEN as varchar) + ' ' + um.ABREVIATURA) as VOLUMEN_ENVASE_PRIMARIO,fm.CANTIDAD_LOTE,ppm.CANTIDAD,cpm.NOMBRE_COLORPRESPRIMARIA" +
                                    ",cpr.COD_RECETA_DESPIROGENIZADO"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_ESTADO_REGISTRO=1 and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                                    " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD" +
                                    " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA" +
                                    " left outer join COLORES_PRESPRIMARIA cpm on cpm.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA"+
                                    " left outer join COMPONENTES_PROD_RECETA cpr on cpr.COD_COMPROD=cp.COD_COMPPROD" +
                                    " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =cp.COD_UNIDAD_MEDIDA_VOLUMEN" +
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
                    String abreviaturaForma="";
                    String abreviaturaTP="ABREVIATURA";
                    String codComprodMix="";
                    Double[] prod1=new Double[3];
                    Double[] prod2=new Double[3];
                    int codForma=0;
                    String nombreColor="";
                    String volumenEnvasePrimario="";
                    String cantidadEnvasePrimario="";
                    String pesoEnvasePrimario="";
                    String codRecetaDes="";
                    if(res.next())
                    {
                        codRecetaDes=res.getString("COD_RECETA_DESPIROGENIZADO");
                        System.out.println(codRecetaDes);
                        codComprodMix=res.getString("COD_COMPPROD");
                        prod1[0]=res.getDouble("COD_COMPPROD");
                        prod1[1]=(res.getDouble("CANT_LOTE_PRODUCCION")/res.getDouble("CANTIDAD_LOTE"));
                        prod1[2]=res.getDouble("COD_FORMULA_MAESTRA");
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
                           if(!codComprodMix.equals(res.getString("COD_COMPPROD")))
                           {
                               codComprodMix+=","+res.getString("COD_COMPPROD");

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

                        out.println("<tr ><th colspan='2' style='border-bottom: solid #000000 1px;border-right : solid #000000 1px' rowspan='3'><center><img src='../../../img/cofar.png'></center></th>" +
                                "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='outputText2'><b>FORMULA MAESTRA</b></span></th>" +
                                "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center' style='font-style:normal;'><span class='normal'>Número de Página</span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><input type='text' size='3' value='0' class='inputText' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='outputText2'><b>&nbsp;de&nbsp;</b></span></th>" +
                                "<th style='border-bottom : solid #000000 1px' align='center'><input type='text' size='3' value='0' class='inputText' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "</tr>" +
                                "<tr>" +
                                "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center' rowspan='2'><span class='outputText2'><b>DESPEJE DE LINEA,<br> LIMPIEZA DE AMBIENTES</b></span></th>" +
                                "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Lote</span></th>" +
                                "<th style='border-bottom: solid #000000 1px;' align='left' colspan='3'><span class='normal'>"+codLote+"</span></th>" +
                                "</tr><tr>" +
                                "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Expiración</span></th>" +
                                "<th style='border-bottom : solid #000000 1px' align='left' colspan='3'><span class='normal'>"+(fecha!=null?sdf.format(fecha):"")+"</span></th>" +
                                "</tr><tr>" +
                                "<th  colspan='9' style='border-bottom: solid #000000 1px;' align='left'>&nbsp;</th>" +
                                "</tr><tr>" +
                                "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Nombre Comercial</span></th>" +
                                "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='outputText2'><b>"+nombreProd+"</b></span></th>" +
                                "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Presentación</span></th>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;' align='left'><span class='normal'>"+nombreEnvasePrimario+"</span></th>" +
                                "</tr><tr>" +
                                "<th colspan='2' rowspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Concentración</span></th>" +
                                "<th colspan='2' rowspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>&nbsp;"+concentracion+"</span></th>" +
                                "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>N° de Registro Sanitario</span></th>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;' align='left'><span class='normal'>"+registroSanitario+"</span></th>" +
                                "</tr><tr>" +
                                "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Vida util del producto</span></th>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;' align='left'><span class='normal'>"+vidaUtil+" meses</span></th>" +
                                "</tr><tr>" +
                                "<th colspan='2' style='border-right:solid #000000 1px' align='left'><span class='normal'>Forma Farmaceútica</span></th>" +
                                "<th colspan='2' style='border-right:solid #000000 1px' align='left'><span class='normal'>"+nombreForma+"</span></th>" +
                                "<th colspan='2' style='border-right:solid #000000 1px' align='left'><span class='normal'>Tamaño de Lote Industrial</span></th>" +
                                "<th colspan='2'  style='border-right:solid #000000 1px' align='left'><span class='normal'>"+tamLote+"</span></th>" +
                                "<th align='left'><span class='normal'>"+abreviaturaForma+"</span></th>" +
                                "</tr><tr><th style='padding:2px;border-top:solid #000000 1px;border-bottom:solid #000000 1px' colspan='9'>&nbsp;</th></tr>"
                                );
                        consulta="select dpom.INDICACIONES_LIMPIEZA_AMBIENTE,dpom.INDICACIONES_LIMPIEZA_EQUIPOS"+
                                 " from DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpom where dpom.COD_FORMA='"+codForma+"'";
                        res=st.executeQuery(consulta);
                        String indicacionesLimpiezaEquipos="";
                        if(res.next())
                        {
                            String condiciones=res.getString("INDICACIONES_LIMPIEZA_AMBIENTE").replace(b,'\n');
                            condiciones=condiciones.replace("\n", "</br>");
                            indicacionesLimpiezaEquipos=res.getString("INDICACIONES_LIMPIEZA_EQUIPOS").replace(b,'\n');
                            indicacionesLimpiezaEquipos=indicacionesLimpiezaEquipos.replace("\n", "</br>");
                            out.println("<tr>" +
                                "<th bgcolor='#cccccc' colspan='9' style='padding:5px;font-size:16px;border-bottom: solid #000000 1px;' align='center'><span class='outputText2'>REGISTRO DE LIMPIEZA DE AMBIENTES</span></th>" +
                                "</tr>"+
                                "<tr><th colspan='9' style='padding:6px;border-bottom: solid #000000 1px;' align='left'><span class='normal' ></span><p/><span class='normal' >"+condiciones.replace(c,' ')+"</span></th>" +
                                "</tr><tr bgcolor='#cccccc'>" +
                                "<th rowspan='3' colspan=2 style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>SECCION</b></span></th>" +
                                "<th rowspan='3' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>NOMBRE DE LA PERSONA RESPONSABLE DE LIMPIEZA</b></span></th>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>TIPO DE LIMPIEZA</b></span></th>" +
                                "<th rowspan='3' colspan='2'  style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>NOMBRE DEL RESP. DE VERIF. DEL DESPEJE DE LINEA</b></span></th>" +
                                "<th rowspan='3' style='border-bottom: solid #000000 1px;width:120px;' align='center'><span class='normal' ><b>FECHA</b></span></th>" +
                                "</tr><tr bgcolor='#cccccc'>" +
                                "<th rowspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>Sanitizante</b></span></th>" +
                                "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>Limpieza</b></span></th>" +
                                "</tr><tr bgcolor='#cccccc'>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>Radical</b></span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>Ordinaria</b></span></th>" +
                                "</tr>"
                                );
                        }
                        consulta="select som.NOMBRE_SECCION_ORDEN_MANUFACTURA"+
                                 " from SECCIONES_ORDEN_MANUFACTURA som where som.COD_FORMA='"+codForma+"' order by som.NOMBRE_SECCION_ORDEN_MANUFACTURA";
                        System.out.println("consulta cargar especificaciones"+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr>" +
                                    "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px;' align='center'><span class='normal' >"+res.getString("NOMBRE_SECCION_ORDEN_MANUFACTURA")+"</span></th>" +
                                    "<th  style='border-bottom: solid #000000 1px;border-right:solid #000000 1px;width:25%' align='center'><span class='normal' >&nbsp;</span></th>" +
                                    "<th  style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' >&nbsp;</span></th>" +
                                    "<th  style='border-bottom: solid #000000 1px;border-right:solid #000000 1px;width:7%' align='center'><span class='normal' >&nbsp;</span></th>" +
                                    "<th  style='border-bottom: solid #000000 1px;border-right:solid #000000 1px;width:7%' align='center'><span class='normal' >&nbsp;</span></th>" +
                                    "<th colspan='2'  style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' >&nbsp;</span></th>" +
                                    "<th  style='border-bottom: solid #000000 1px;' align='center'><span class='normal' >&nbsp;</span></th>" +
                                    "</tr>");
                        }
                        out.println("<tr>" +
                                "<th colspan='9' class='normal' style='border-bottom: solid #000000 1px;' align='left'>" +
                                " Fecha :  .................................<br>" +
                                " OBSERVACIONES :  ...................................................................................................................................................................................................................................<br>" +
                                " ........................................................................................................................................................................................................................................................................" +
                                "</th>" +
                                "</tr>" +
                                "<tr><th bgcolor='#cccccc' colspan='9' style='padding:3px;font-size:16px;border-bottom: solid #000000 1px;' align='center'><span class='outputText2'>REGISTRO DE LIMPIEZA DE EQUIPOS</span></th></tr>" +
                                "<tr><th bgcolor='#cccccc' colspan='9' style='padding:3px;font-size:16px;border-bottom: solid #000000 1px;' align='center'><span class='outputText2'>CONTROL DE LIMPIEZA</span></th></tr>" +
                                "<tr><th colspan='9' style='padding:6px;' align='left'><span class='normal' ></span><p/><span class='normal' >"+indicacionesLimpiezaEquipos.replace(c,' ')+"</span></th>" +
                                "</tr><tr><th colspan='9' style='padding:6px;' align='center'>" +
                                "<table cellpadding='0' cellspacing='0' style='border-top:1px solid black;border-left:1px solid black;width:80%'>" +
                                "<tr bgcolor='#cccccc'>" +
                                "<th rowspan='3' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px;'><span class='normal' style='font-weight:bold'>EQUIPO</span></th>" +
                                "<th rowspan='3' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px;'><span class='normal' style='font-weight:bold'>CODIGO</span></th>" +
                                "<th rowspan='3' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px;width:30%'><span class='normal' style='font-weight:bold;'>NOMBRE DE LA PERSONA RESPONSABLE DE LA LIMPIEZA</span></th>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px;'><span class='normal' style='font-weight:bold'>TIPO DE LIMPIEZA</span></th>" +
                                "</tr><tr bgcolor='#cccccc'>" +
                                "<th rowspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px;'><span class='normal' style='font-weight:bold'>Sanitizante/ detergente</span></th>" +
                                "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px;'><span class='normal' style='font-weight:bold'>Limpieza</span></th>" +
                                "</tr><tr bgcolor='#cccccc'>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px;'><span class='normal' style='font-weight:bold'>Radical</span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px;'><span class='normal' style='font-weight:bold'>Ordinaria</span></th>" +
                                "</tr>");
                        consulta="select m.NOMBRE_MAQUINA,m.CODIGO from MAQUINARIAS m where m.COD_ESTADO_REGISTRO=1 and ("+
                                " (m.COD_MAQUINA in (select ppeq.COD_MAQUINA from PROCESOS_PRODUCTO_ESP_EQUIP ppeq inner join PROCESOS_PRODUCTO pp on "+
                                " pp.COD_PROCESO_PRODUCTO=ppeq.COD_PROCESO_PRODUCTO where pp.COD_COMPPROD='"+codCompProd+"')) OR"+
                                " (m.COD_MAQUINA in (select sppeq.COD_MAQUINA from SUB_PROCESOS_PRODUCTO_ESP_EQUIP sppeq inner join PROCESOS_PRODUCTO pp1 on "+
                                " pp1.COD_PROCESO_PRODUCTO=sppeq.COD_PROCESO_PRODUCTO where pp1.COD_COMPPROD='"+codCompProd+"')))"+
                                " and m.COD_TIPO_EQUIPO not in (8) order by m.NOMBRE_MAQUINA";
                        System.out.println("consulta maquinarias producto procesos "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr>" +
                                "<th  style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>"+res.getString("NOMBRE_MAQUINA")+"</b></span></th>" +
                                "<th  style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>"+res.getString("CODIGO")+"&nbsp;</b></span></th>" +
                                "<th  style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>&nbsp;</b></span></th>" +
                                "<th  style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>&nbsp;</b></span></th>" +
                                "<th  style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>&nbsp;</b></span></th>" +
                                "<th  style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='normal' ><b>&nbsp;</b></span></th>" +
                                "</tr>");
                        }
                        out.println("</table></th></tr><tr>" +
                                "<th colspan='9' class='normal' style='padding-top:6px' align='left'>" +
                                " Nombre de la persona que verifica :  ..........................................................................<br>" +
                                " Fecha :  .....................................<br>" +
                                " OBSERVACIONES :  ...................................................................................................................................................................................................................................<br>" +
                                " ........................................................................................................................................................................................................................................................................" +
                                "</th>" +
                                "</tr>");
                        res.close();
                        con.close();
                    
                    }catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
                %>
                
            </table>

            <%--div id="diagrama"></div></center>
            <table width="80%" align="center" class="outputText0" style="border : solid #000000 1px;" cellpadding="3" cellspacing="3" >
                <tr><td align="left"><span class="normal"> Responsable de verficicación:_________________________________________________________________</span></td></tr>
                <tr><td align="left"><span class="normal">Fecha:__/__/__</span></td></tr>
                <tr><td align="left"><span class="normal">Firma:________________________</span></td></tr>
            </table>
        <input type="hidden" value="<%=cantPixeles%>" id="tamTexto"/--%>
        
</div>
    </body>
</html>
