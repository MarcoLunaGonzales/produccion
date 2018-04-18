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
             



            <table width="80%" align="center" class="outputText0" style="border-top: solid #000000 1px;border-left: solid #000000 1px;border-right: solid #000000 1px;" cellpadding="0" cellspacing="0" >
                 <%
                  try
                  {
                    NumberFormat nf1 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat formato= (DecimalFormat)nf1;
                    formato.applyPattern("####.#####");
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select isnull(cpr.COD_RECETA_LAVADO, 0) as cod_receta_lavado,f.cod_forma,pp.COD_FORMULA_MAESTRA,cp.COD_COMPPROD,f.abreviatura_forma,p.nombre_prod,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL,cp.cod_area_empresa" +
                                    " ,cp.PESO_ENVASE_PRIMARIO,tpp.ABREVIATURA as abtp,(cast (cp.CANTIDAD_VOLUMEN as varchar) + ' ' + um.ABREVIATURA) as VOLUMEN_ENVASE_PRIMARIO,fm.CANTIDAD_LOTE,ppm.CANTIDAD,cpm.NOMBRE_COLORPRESPRIMARIA" +
                                    " ,ISNULL(cpr.ENVASADO_CON_GAS_NITROGENO, 0) as ENVASADO_CON_GAS_NITROGENO,cpr.COD_RECETA_DOSIFICADO" +
                                    " ,dpff.PRECAUCIONES_DOSIFICADO,dpff.PRE_INDICACIONES_DOSIFICADO,dpff.INDICACIONES_DOSIFICADO,dpff.POST_INDICACIONES_DOSIFICADO"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_ESTADO_REGISTRO=1 and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                                    " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD" +
                                    " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA" +
                                    " left outer join COLORES_PRESPRIMARIA cpm on cpm.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA" +
                                    " left outer join COMPONENTES_PROD_RECETA cpr on cpr.COD_COMPROD=cp.COD_COMPPROD" +
                                    " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =cp.COD_UNIDAD_MEDIDA_VOLUMEN" +
                                    "  left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA"+
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
                    double tamañoLote=0d;
                    String codReceta="";
                    boolean envasadoNitrogeno=false;
                    int codRecetaDosificado=0;
                    List<String>especificacionesFiltrado=new ArrayList<String>();
                    String precaucionesDosificado="";
                    String preIndicacionesDosificado="";
                    String indicacionesDosificado="";
                    String postIndicacionesDosificado="";
                    if(res.next())
                    {
                        precaucionesDosificado=res.getString("PRECAUCIONES_DOSIFICADO");
                        preIndicacionesDosificado=res.getString("PRE_INDICACIONES_DOSIFICADO");
                        indicacionesDosificado=res.getString("INDICACIONES_DOSIFICADO");
                        postIndicacionesDosificado=res.getString("POST_INDICACIONES_DOSIFICADO");
                        codRecetaDosificado=res.getInt("COD_RECETA_DOSIFICADO");
                        envasadoNitrogeno=(res.getInt("ENVASADO_CON_GAS_NITROGENO")>0);
                        codReceta=res.getString("cod_receta_lavado");
                        codComprodMix=res.getString("COD_COMPPROD");
                        prod1[0]=res.getDouble("COD_COMPPROD");
                        prod1[1]=(res.getDouble("CANT_LOTE_PRODUCCION")/res.getDouble("CANTIDAD_LOTE"));
                        tamañoLote=res.getDouble("CANT_LOTE_PRODUCCION");
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
                            tamañoLote+=res.getDouble("CANT_LOTE_PRODUCCION");
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
                                "<th colspan='3' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='outputText2'><b>FORMULA MAESTRA</b></span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center' style='font-style:normal;'><span class='normal'>Número de Página</span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><input type='text' size='3' value='0' class='inputText' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='outputText2'><b>&nbsp;de&nbsp;</b></span></th>" +
                                "<th style='border-bottom : solid #000000 1px' align='center'><input type='text' size='3' value='0' class='inputText' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "</tr>" +
                                "<tr>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center' rowspan='2'><span class='outputText2'><b>PROCESO DE DOSIFICADO</b></span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Lote</span></th>" +
                                "<th style='border-bottom: solid #000000 1px;' align='left' colspan='3'><span class='normal'>"+codLote+"</span></th>" +
                                "</tr><tr>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Expiración</span></th>" +
                                "<th style='border-bottom : solid #000000 1px' align='left' colspan='3'><span class='normal'>"+(fecha!=null?sdf.format(fecha):"")+"</span></th>" +
                                "</tr><tr>" +
                                "<th  colspan='9' style='border-bottom: solid #000000 1px;' align='left'>&nbsp;</th>" +
                                "</tr><tr>" +
                                "<th colspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Nombre Comercial</span></th>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='outputText2'><b>"+nombreProd+"</b></span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Presentación</span></th>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;' align='left'><span class='normal'>"+nombreEnvasePrimario+"</span></th>" +
                                "</tr><tr>" +
                                "<th colspan='2' rowspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Concentración</span></th>" +
                                "<th colspan='3' rowspan='2' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>"+concentracion+"&nbsp;</span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>N° de Registro Sanitario</span></th>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;' align='left'><span class='normal'>"+registroSanitario+"</span></th>" +
                                "</tr><tr>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Vida util del producto</span></th>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;' align='left'><span class='normal'>"+vidaUtil+" meses</span></th>" +
                                "</tr><tr>" +
                                "<th colspan='2' style='border-right:solid #000000 1px' align='left'><span class='normal'>Forma Farmaceútica</span></th>" +
                                "<th colspan='3' style='border-right:solid #000000 1px' align='left'><span class='normal'>"+nombreForma+"</span></th>" +
                                "<th style='border-right:solid #000000 1px' align='left'><span class='normal'>Tamaño de Lote Industrial</span></th>" +
                                "<th colspan='2'  style='border-right:solid #000000 1px' align='left'><span class='normal'>"+tamLote+"</span></th>" +
                                "<th align='left'><span class='normal'>"+abreviaturaForma+"</span></th>" +
                                "</tr>"
                                );
                       
                            out.println("<tr>" +
                                "<th bgcolor='#cccccc' colspan='9' style='padding:3px;font-size:16px;border-top: solid #000000 1px;border-bottom: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;'>DOSIFICADO</span></th>" +
                                "</tr><tr><th style='padding:5px;' align='left' colspan='9'><span class='outputText2' style='font-weight:normal;font-size:12px;'><b>PRECAUCIONES:</b>&nbsp;&nbsp;"+precaucionesDosificado+"</span></th>"+
                                "</tr>");
                            consulta="select m.NOMBRE_MAQUINA from MAQUINARIAS m where m.COD_MAQUINA in (163,164) order by m.NOMBRE_MAQUINA";
                            res=st.executeQuery(consulta);
                            out.println("<tr><th bgcolor='' colspan='9' style='padding:3px;font-size:16px;border-bottom: solid #000000 1px;' align='center'>" +
                                        "<table cellpadding='0' style='width:100%' cellspacing='0'><tr>");
                            while(res.next())
                            {
                               out.println("<td style='width:50%' align='left'><span class='outputText2' style='font-weight:normal'>"+res.getString("NOMBRE_MAQUINA")+"</span><input type='checkbox'/></td>");
                            }
                            out.println("</tr></table></th></tr>");
                           out.println("<tr><th bgcolor='#cccccc' colspan='9' style='padding:3px;font-size:16px;border-bottom: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;'>DATOS PARA FILTRAR</span></th>" +
                                "</tr><tr>" +
                                "<th style='padding:5px;border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left' colspan='9'>" +
                                "<span class='outputText2' style='line-height:20px;font-weight:normal;font-size:12px;'>"+preIndicacionesDosificado.replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>")+"</span></th>"+
                                "</tr><tr>" +
                                "<th bgcolor='#cccccc' colspan='4' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>ESPECIFICACIONES</span></th>" +
                                "<th bgcolor='#cccccc' colspan='5' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>CONDICIONES DEL PROCESO</span></th>" +
                                "</tr><tr>" +
                                "<th bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>Poro del filtro</span></th>" +
                                "<th bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>Número de filtros</span></th>" +
                                "<th bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>Presión de aprobación</span></th>" +
                                "<th bgcolor='#cccccc' style='padding:2sspx;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>Medio de filtracion</span></th>" +
                                "<th  colspan='2' bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>Prueba de integridad</span></th>" +
                                "<th bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>Presión Registrada</span></th>" +
                                "<th colspan='2' bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal' >Numero de filtros utilizados para todo el proceso</span></th>" +
                                "</tr>"

                                );
                       
                        consulta="select ef.CANTIDAD_FILTRO,mf.NOMBRE_MEDIO_FILTRACION,um.ABREVIATURA,"+
                                 " ef.NUMERO_DE_FILTROS,ef.PRESION_DE_APROBACION,um1.ABREVIATURA as unidad_presion"+
                                 " from ESPECIFICACIONES_FILTRADO ef"+
                                 " inner join UNIDADES_MEDIDA um on ef.COD_UNIDAD_MEDIDA ="+
                                   "  um.COD_UNIDAD_MEDIDA and ef.cod_estado_registro = 1"+
                                   "  inner join MEDIOS_FILTRACION mf on mf.COD_MEDIO_FILTRACION ="+
                                   "  ef.COD_MEDIO_FILTRACION"+
                                   "  inner join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA ="+
                                   "  ef.COD_UNIDAD_MEDIDA_PRESION inner join especificaciones_filtrado_producto efp on" +
                                   " efp.cod_especificacion_filtrado=ef.cod_especificacion_filtrado and efp.cod_compprod='"+codCompProd+"'"+
                                 " order by ef.CANTIDAD_FILTRO";

                        System.out.println("consulta cargar esp filtrado"+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            especificacionesFiltrado.add(res.getString("CANTIDAD_FILTRO")+" "+res.getString("ABREVIATURA"));
                            out.println("<tr><td align='center' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>"+res.getString("CANTIDAD_FILTRO")+" "+res.getString("ABREVIATURA")+"</span></td>" +
                                        "<td align='right' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>"+res.getInt("NUMERO_DE_FILTROS")+"</span></td>" +
                                        "<td align='center' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>"+res.getString("PRESION_DE_APROBACION")+" "+res.getString("unidad_presion")+"</span></td>" +
                                        "<td align='center' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>"+res.getString("NOMBRE_MEDIO_FILTRACION")+"</span></td>" +
                                        "<td align='center' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>POSITIVO</span></td>" +
                                        "<td align='center' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><input type='checkbox'/></td>" +
                                        "<td align='center' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'>&nbsp;</td>" +
                                        "<td align='center' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'>&nbsp;</td>" +
                                        "<td align='center' style='padding:4px;border-bottom:solid #000000 1px;'><span class='outputText2'>"+res.getString("unidad_presion")+"</span></td>" +
                                    "</tr>");

                        }
                        if(envasadoNitrogeno)out.println("<tr><td align='center' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>Medio de filtración</span></td>" +
                                "<td colspan='2' align='center' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>NITROGENO</span></td><td colspan='6'>&nbsp;</td></tr>");
                        out.println("<tr>" +
                                "<th style='padding:5px;border-bottom: solid #000000 1px' align='left' colspan='9'>" +
                                "<span class='outputText2' style='line-height:20px;font-weight:normal;font-size:12px;'>" +
                                "<b>NOMBRE DEL OPERARIO RESPONSABLE DE LA PRUEBA:</b>.............................................................................................................................................<br>" +
                                "<b>FECHA DE LA PRUEBA DE INTEGRIDAD:</b>................................................................................................................................................................<br>" +
                                "<b>NOMBRE DEL SUPERVISOR</b>(Técnico y/o Jefe de Producción).....................................................................................................................................<br>" +
                                indicacionesDosificado.replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>")+
                                (envasadoNitrogeno?"<b>7. ENVASAR EL PRODUCTO CON GAS NITROGENO</b>":"")+
                                "</span></th></tr>");
                        out.println("<tr>" +
                                "<th bgcolor='#cccccc' colspan='4' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>ESPECIFICACIONES</span></th>" +
                                "<th bgcolor='#cccccc' colspan='5' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>CONDICIONES DE OPERACION DEL EQUIPO</span></th>" +
                                "</tr><tr>" +
                                "<th colspan='2' bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>Máquina</span></th>" +
                                "<th bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>Valor</span></th>" +
                                "<th bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>Unidades</span></th>" +
                                "<th colspan='3' bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>Máquina</span></th>" +
                                "<th bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>Valor</span></th>" +
                                "<th bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;font-weight:normal'>Unidades</span></th>" +
                                "</tr>");
                        consulta="select ep.RESULTADO_NUMERICO,ep.NOMBRE_ESPECIFICACIONES_PROCESO,isnull(um.ABREVIATURA, 'N.A.') as ABREVIATURA,"+
                                 " case when ep.ESPECIFICACION_STANDAR_FORMA = 1 then ep.VALOR_EXACTO when epdp.COD_COMPPROD >0 then epdp.VALOR_EXACTO"+
                                 " else rd.VALOR_EXACTO end as valorExacto, case when ep.ESPECIFICACION_STANDAR_FORMA = 1 THEN ep.VALOR_TEXTO"+
                                 " when epdp.COD_COMPPROD >0 then epdp.VALOR_TEXTO else rd.VALOR_TEXTO end as valorTexto"+
                                 " from ESPECIFICACIONES_PROCESOS ep left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =ep.COD_UNIDAD_MEDIDA"+
                                 " left outer join RECETAS_DESPIROGENIZADO rd on rd.COD_ESPECIFICACION_PROCESO"+
                                 " = ep.COD_ESPECIFICACION_PROCESO and rd.COD_RECETA = '"+codRecetaDosificado+"'" +
                                 " left outer join ESPECIFICACIONES_PROCESOS_DOSIFICADO_PRODUCTO epdp"+
                                 " on epdp.COD_ESPECIFICACION_PROCESO=ep.COD_ESPECIFICACION_PROCESO"+
                                 " and epdp.COD_COMPPROD='"+codCompProd+"'"+
                                 " where ep.COD_FORMA = '"+codForma+"' and ep.COD_PROCESO_ORDEN_MANUFACTURA = 3 order by ep.ORDEN";
                        System.out.println("consulta cargar Especificaciones "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr>" +
                                        "<td colspan='2' align='left' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>"+res.getString("NOMBRE_ESPECIFICACIONES_PROCESO")+"</span></td>" +
                                        "<td align='center' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>"+(res.getInt("RESULTADO_NUMERICO")>0?res.getString("valorExacto"):res.getString("valorTexto"))+"</span></td>" +
                                        "<td align='center' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>"+res.getString("ABREVIATURA")+"</span></td>" +
                                        "<td colspan='3' align='left' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>"+res.getString("NOMBRE_ESPECIFICACIONES_PROCESO")+"</span></td>" +
                                        "<td align='center' style='padding:4px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>&nbsp;</span></td>" +
                                        "<td align='center' style='padding:4px;border-bottom:solid #000000 1px;'><span class='outputText2'>"+res.getString("ABREVIATURA")+"</span></td>" +
                                        "</tr>");
                        }
                        out.println("<tr>" +
                                        "<td bgcolor='#cccccc' colspan='4' align='center' style='padding:2px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>Nombre de la persona que aprueba el peso y la altura del sellado</span></td>" +
                                        "<td colspan='5' align='center' style='padding:4px;border-bottom:solid #000000 1px;'><span class='outputText2'>&nbsp;</span></td>" +
                                        "</tr>");
                        out.println("<tr>" +
                                "<th style='padding:2px;border-bottom: solid #000000 1px' align='left' colspan='9'>" +
                                "<span class='outputText2' style='line-height:20px;font-weight:normal;font-size:12px;'>" +
                                (envasadoNitrogeno?"8.":"7.")+postIndicacionesDosificado.replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>")+
                                "</span></th></tr><tr>" +
                                "<th rowspan='2' bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span  style='font-size:12px;font-weight:normal'>Porosidad de menbrana</span></th>" +
                                "<th colspan='2' bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span  style='font-size:12px;font-weight:normal'>Prueba de integridad</span></th>" +
                                "<th rowspan='2' bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span  style='font-size:12px;font-weight:normal'>Presión registrada</span></th>" +
                                "<th colspan='2' rowspan='2' bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span  style='font-size:12px;font-weight:normal'>Nombres del operario</span></th>" +
                                "<th colspan='3' rowspan='2' bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;' align='center'><span  style='font-size:12px;font-weight:normal' >Observaciones</span></th>" +
                                "</tr><tr><th bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span  style='font-size:12px;font-weight:normal'>Positivo</span></th>" +
                                "<th bgcolor='#cccccc' style='padding:2px;font-size:12px;border-bottom: solid #000000 1px;border-right: solid #000000 1px;' align='center'><span  style='font-size:12px;font-weight:normal'>Negativo</span></th></tr>");
                        for(String especificacion:especificacionesFiltrado)
                        {
                            out.println("<tr>" +
                                        "<td align='center' style='padding:3px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'><span class='outputText2'>"+especificacion+"</span></td>" +
                                        "<td align='right' style='padding:3px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'>&nbsp;</td>" +
                                        "<td align='center' style='padding:3px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'>&nbsp;</td>" +
                                        "<td align='center' style='padding:3px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'>&nbsp;</td>" +
                                        "<td colspan='2' align='center' style='padding:3px;border-right: solid #000000 1px;border-bottom:solid #000000 1px;'>&nbsp;</td>" +
                                        "<td colspan='3' align='center' style='padding:3px;border-bottom:solid #000000 1px;'>&nbsp;</td>" +
                                        "</tr>");
                        }
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
