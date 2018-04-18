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
<html>
   <head>
   <style>
    table
    {
        border-top:1px solid black ;
        border-left:1px solid black;
    }
    table tr th
    {
        border-bottom:1px solid black;
        border-right:1px solid black;
        padding-left:0.5em;
        padding-right:0.5em;
        padding-top:0.3em;
        padding-bottom:0.3em;
    }
    
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
    @media print{
        .pagina{
            border:1px solid black;
            height:100%;
            width:100%;
            border-collapse:collapse;
        }
        table{
            width:100%;
            border:none;
        }
        
        table tr th table
        {
            border-top:1px solid black;
            border-left:1px solid black;
            width:90%;
        }
        .ultCol
        {
            border-right:none;
        }
        .ultFil
        {
            border-bottom:none;
            height:100%;
            vertical-align:super;
        }
    }
    .pagina 
    {
        page-break-inside:auto;
    }
    
</style>
</head>
 <body >
     
<div class="pagina">
    <table width="80%" align="center" class="outputText0"  cellpadding="0" cellspacing="0" >
                 <%
                 String loteAsociado="";
                 int cantAsociado=0;
                 NumberFormat nf1 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formato= (DecimalFormat)nf1;
                formato.applyPattern("####.#####");
                int codProgramaProd=Integer.valueOf(request.getParameter("codProgramaProd"));
                String codLoteProduccion=request.getParameter("codLote");
                String fechaVencimiento="";
                int codCompProd=0;
                String nombreProducto="";
                int vidaUtil=0;
                SimpleDateFormat sdf=new SimpleDateFormat("MM-yyyy");
                SimpleDateFormat sdfDias=new SimpleDateFormat("dd/MM/yyyy");
                SimpleDateFormat sdfHoras=new SimpleDateFormat("HH:mm");
                String nombreEnvasePrimario="";
                String registroSanitario="";
                String nombreFormaFarmaceutica="";
                String tamLote="";
                String abreviaturaForma="";
                String abreviaturaTP="ABREVIATURA";
                String codComprodMix="";
                Double[] prod1=new Double[4];
                Double[] prod2=new Double[3];
                int codForma=0;
                char b=13;char c=10;
                Date fechaCierre=new Date();
                String personalAprueba="";
                String personalDespeje="";
                int codSeguimiento=0;
                String observacion="";
                int codRecetaEsterilizacion=0;
                int codActividadMazden=0;
                  try
                  {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select pp.cod_formula_maestra,f.cod_forma,pp.COD_FORMULA_MAESTRA,cp.COD_COMPPROD,f.abreviatura_forma,p.nombre_prod,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL,cp.cod_area_empresa" +
                                    " ,cp.PESO_ENVASE_PRIMARIO,tpp.ABREVIATURA as abtp,(cast (cp.CANTIDAD_VOLUMEN as varchar) + ' ' + um.ABREVIATURA) as VOLUMEN_ENVASE_PRIMARIO,fm.CANTIDAD_LOTE,ppm.CANTIDAD,cpm.NOMBRE_COLORPRESPRIMARIA" +
                                    " ,cp.CANTIDAD_VOLUMEN,um.ABREVIATURA,cp.TOLERANCIA_VOLUMEN_FABRICAR,tpp.COD_TIPO_PROGRAMA_PROD,tpp.COD_TIPO_PROGRAMA_PROD" +
                                    ",ISNULL((select top 1 spp.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp"+
                                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = spp.COD_ACTIVIDAD_PROGRAMA and"+
                                    "  spp.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA where spp.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION and afm.COD_ACTIVIDAD = 186"+
                                    "  order by spp.FECHA_FINAL DESC ), (select top 1 spp1.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp1"+
                                    "  inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = spp1.COD_ACTIVIDAD_PROGRAMA and"+
                                    "  spp1.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA where spp1.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION and afm.COD_ACTIVIDAD in (71,48) "+
                                    "  order by spp1.FECHA_FINAL DESC )) as fecha," +
                                    "  ISNULL(dpff.INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO, '') as INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO," +
                                    " ISNULL(dpff.PRECAUCIONES_ESTERILIZACION_CALOR_HUMEDO, '') as PRECAUCIONES_ESTERILIZACION_CALOR_HUMEDO,"+
                                    " isnull(dpff.POST_INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO, '') as POST_INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO"+
                                    " ,sechl.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE,sechl.FECHA_CIERRE"+
                                    " ,(per.AP_PATERNO_PERSONAL+' '+per.AP_MATERNO_PERSONAL+' '+per.NOMBRES_PERSONAL+' '+per.nombre2_personal) as nombrePersonal" +
                                    ", (per1.AP_PATERNO_PERSONAL + ' ' + per1.AP_MATERNO_PERSONAL + ' ' +per1.NOMBRES_PERSONAL + ' ' + per1.nombre2_personal) as nombreApruebaDespeje"+
                                    " ,isnull(loteAsociado.loteAsociado,'') as loteAsociado,isnull(loteAsociado.cantAsociado,0) as cantAsociado" +
                                    " ,sechl.OBSERVACIONES,isnull(cpr.COD_RECETA_ESTERILIZACION_CALOR, 0) as COD_RECETA_ESTERILIZACION_CALOR" +
                                    " ,isnull(afm2.COD_ACTIVIDAD_FORMULA, 0) as codActividadMAzden"+
                                    " from PROGRAMA_PRODUCCION pp inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                    " inner join FORMAS_FARMACEUTICAS f on f.cod_forma=cp.COD_FORMA"+
                                    " inner join productos p on p.cod_prod=cp.COD_PROD"+
                                    " inner join PRESENTACIONES_PRIMARIAS ppm on ppm.COD_COMPPROD=cp.COD_COMPPROD and ppm.COD_ESTADO_REGISTRO=1 and ppm.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                    " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim=ppm.COD_ENVASEPRIM" +
                                    " inner join PROGRAMA_PRODUCCION_PERIODO ppp on pp.COD_PROGRAMA_PROD=ppp.COD_PROGRAMA_PROD"+
                                    " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD" +
                                    " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=pp.COD_FORMULA_MAESTRA" +
                                    " left outer join COLORES_PRESPRIMARIA cpm on cpm.COD_COLORPRESPRIMARIA=cp.COD_COLORPRESPRIMARIA" +
                                    " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cp.COD_UNIDAD_MEDIDA_VOLUMEN" +
                                    " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA"+
                                    " inner join SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE sechl on sechl.COD_PROGRAMA_PROD =pp.COD_PROGRAMA_PROD and sechl.COD_LOTE = pp.COD_LOTE_PRODUCCION"+
                                    " inner join personal per on per.COD_PERSONAL=sechl.COD_PERSONAL_SUPERVISOR" +
                                    " left outer join personal per1 on per1.COD_PERSONAL = sechl.COD_PERSONAL_APRUEBA_DESPEJE" +
                                    " left outer join COMPONENTES_PROD_RECETA cpr on cpr.COD_COMPROD =cp.COD_COMPPROD" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm2 on afm2.COD_AREA_EMPRESA ="+
                                    " 96 and afm2.COD_ACTIVIDAD = 160 and afm2.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm2.COD_PRESENTACION = 0" +
                                    " outer APPLY(select top 1 lpc.COD_LOTE_PRODUCCION_ASOCIADO as loteAsociado,pp1.CANT_LOTE_PRODUCCION as cantAsociado"+
                                    " from LOTES_PRODUCCION_CONJUNTA lpc inner join PROGRAMA_PRODUCCION pp1 on"+
                                    " lpc.COD_PROGRAMA_PROD=pp1.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION_ASOCIADO=pp1.COD_LOTE_PRODUCCION"+
                                    " where lpc.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION"+
                                    " and pp1.COD_COMPPROD=pp.COD_COMPPROD) loteAsociado"+
                                    " where pp.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and pp.cod_programa_prod='"+codProgramaProd+"'";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    
                    double tamanoLote=0d;
                    
                    String codFormulaMaestra="";
                    double cantidadVolumenEnvase=0d;
                    double toleranciaVolumen=0d;
                    String codTipoprogramaProd="";
                    String indicacionesEsterilizacionCalor="";
                    String postIndicacionesEsterilizacionCalor="";
                    String precaucionesCalorHumedo="";
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat format = (DecimalFormat)nf;
                    format.applyPattern("#,##0.0");
                    if(res.next())
                    {
                        codActividadMazden=res.getInt("codActividadMAzden");
                        codRecetaEsterilizacion=res.getInt("COD_RECETA_ESTERILIZACION_CALOR");
                        personalDespeje=res.getString("nombreApruebaDespeje");
                        observacion=res.getString("OBSERVACIONES");
                        codSeguimiento=res.getInt("COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE");
                        fechaCierre=res.getTimestamp("FECHA_CIERRE");
                        personalAprueba=res.getString("nombrePersonal");
                        codCompProd=res.getInt("COD_COMPPROD");
                        loteAsociado=res.getString("loteAsociado");
                        cantAsociado=res.getInt("cantAsociado");
                        vidaUtil=res.getInt("vida_util");
                        indicacionesEsterilizacionCalor=res.getString("INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        postIndicacionesEsterilizacionCalor=res.getString("POST_INDICACIONES_ETAPA_ESTERILIZACION_CALOR_HUMEDO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        precaucionesCalorHumedo=res.getString("PRECAUCIONES_ESTERILIZACION_CALOR_HUMEDO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        codTipoprogramaProd=res.getString("COD_TIPO_PROGRAMA_PROD");
                        toleranciaVolumen=res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR");
                        codFormulaMaestra=res.getString("cod_formula_maestra");
                        codComprodMix=res.getString("COD_COMPPROD");
                        prod1[0]=res.getDouble("COD_COMPPROD");
                        prod1[1]=(res.getDouble("CANT_LOTE_PRODUCCION")/res.getDouble("CANTIDAD_LOTE"));
                        tamanoLote=res.getDouble("CANT_LOTE_PRODUCCION");
                        prod1[2]=res.getDouble("COD_FORMULA_MAESTRA");
                        prod1[3]=res.getDouble("CANTIDAD_LOTE");
                        cantidadVolumenEnvase=res.getDouble("CANTIDAD_VOLUMEN");
                        abreviaturaTP=res.getString("abtp");
                        if(res.getDate("fecha")!=null)//FECHA_FINAL
                        {
                            Calendar cal = new GregorianCalendar();
                            cal.setTimeInMillis(res.getDate("fecha").getTime());
                            cal.add(Calendar.MONTH, (vidaUtil+(res.getDate("fecha").getDate()>=27?1:0)));
                            fechaVencimiento =sdf.format(new Date(cal.getTimeInMillis()));
                        }
                        else
                        {
                            if(res.getDate("FECHA_FINAL")!=null)
                            {
                                Calendar cal = new GregorianCalendar();
                                cal.setTimeInMillis(res.getDate("FECHA_FINAL").getTime());
                                cal.add(Calendar.MONTH, (vidaUtil+(res.getDate("FECHA_FINAL").getDate()>=27?1:0)));
                                fechaVencimiento =sdf.format(new Date(cal.getTimeInMillis()));
                            }
                            else
                            {
                                fechaVencimiento="No tiene registrado pesaje";
                            }


                        }
                        if(res.getString("cod_area_empresa").equals("81"))
                        {
                            consulta="select FECHA_VENCIMIENTO from INGRESOS_ALMACEN_DETALLE_ESTADO i inner join FORMULA_MAESTRA_DETALLE_EP fmdep on fmdep.COD_MATERIAL = i.COD_MATERIAL" +
                            " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = fmdep.COD_FORMULA_MAESTRA inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD " +
                            " where i.LOTE_MATERIAL_PROVEEDOR = '"+codLoteProduccion+"' ";
                            Statement stdetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet resDet=stdetalle.executeQuery(consulta);
                            if(resDet.next())
                            {
                                fechaVencimiento =sdf.format(resDet.getDate("FECHA_VENCIMIENTO"));
                            }
                            else
                            {
                                fechaVencimiento="No existe stock del lote en almacen";
                            }
                            resDet.close();
                            stdetalle.close();
                       }
                            
                            
                            
                            codForma=res.getInt("cod_forma");
                            nombreFormaFarmaceutica=res.getString("nombre_forma");
                            nombreProducto=res.getString("nombre_prod");
                            nombreEnvasePrimario=res.getString("nombre_envaseprim").toLowerCase();
                            
                            
                            nombreEnvasePrimario+=((codForma==2||codForma==14||codForma==33||codForma==16|| codForma==10||codForma==26||codForma==27||codForma==29)?" "+res.getString("NOMBRE_COLORPRESPRIMARIA")+" por "+formato.format(cantidadVolumenEnvase)+" "+res.getString("ABREVIATURA"):
                                                  ((codForma==6||codForma==1||codForma==32||(codForma>=35&&codForma<=41))?" por "+res.getInt("CANTIDAD")+" "+nombreFormaFarmaceutica.toLowerCase():
                                                 ((codForma==7||codForma==25)?" por "+formato.format(cantidadVolumenEnvase)+" "+res.getString("ABREVIATURA"):
                                                 ((codForma==12||codForma==20||codForma==31||codForma==11||codForma==34||codForma==30||codForma==13)?" por "+res.getString("PESO_ENVASE_PRIMARIO"):
                                                  ((codForma==36)?" por "+res.getInt("CANTIDAD")+"comprimidos":"") ))));

                            
                            registroSanitario=res.getString("REG_SANITARIO");
                            tamLote=res.getString("CANT_LOTE_PRODUCCION");
                            abreviaturaForma=res.getString("abreviatura_forma").toLowerCase();
                       }
                       if(res.next())
                       {
                            prod2[0]=res.getDouble("COD_COMPPROD");
                            prod2[1]=(res.getDouble("CANT_LOTE_PRODUCCION")/res.getDouble("CANTIDAD_LOTE"));
                            prod2[2]=res.getDouble("COD_FORMULA_MAESTRA");
                            tamanoLote+=res.getDouble("CANT_LOTE_PRODUCCION");
                            codTipoprogramaProd+=","+res.getString("COD_TIPO_PROGRAMA_PROD");
                           if(!codComprodMix.equals(res.getString("COD_COMPPROD")))
                           {
                               codComprodMix+=","+res.getString("COD_COMPPROD");
                           }
                           nombreEnvasePrimario+=" ("+abreviaturaTP+") y "+res.getString("nombre_envaseprim").toLowerCase();
                            
                            
                            codForma=res.getInt("cod_forma");
                            nombreFormaFarmaceutica=res.getString("nombre_forma");
                            nombreProducto=res.getString("nombre_prod");
                            nombreEnvasePrimario+=((codForma==2||codForma==14||codForma==33||codForma==16|| codForma==10||codForma==26||codForma==27||codForma==29)?" "+res.getString("NOMBRE_COLORPRESPRIMARIA")+" por "+formato.format(cantidadVolumenEnvase)+" "+res.getString("ABREVIATURA"):
                                                  ((codForma==6||codForma==1||codForma==32||(codForma>=35&&codForma<=41))?" por "+res.getInt("CANTIDAD")+" "+nombreFormaFarmaceutica.toLowerCase():
                                                 ((codForma==7||codForma==25)?" por "+formato.format(cantidadVolumenEnvase)+" "+res.getString("ABREVIATURA"):
                                                 ((codForma==12||codForma==20||codForma==31||codForma==11||codForma==34||codForma==30||codForma==13)?" por "+res.getString("PESO_ENVASE_PRIMARIO"):
                                                  ((codForma==36)?" por "+res.getInt("CANTIDAD")+"comprimidos":"") ))))+"("+res.getString("abtp")+")";
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


                        out.println("<tr ><th colspan='2' rowspan='3'><center><img src='../../../img/cofar.png'></center></th>" +
                                "<th colspan='3' align='center'><span class='bold'><b>FORMULA MAESTRA</b></span></th>" +
                                "<th  align='center'><span class='normal'>Número de Página</span></th>" +
                                "<th  align='center'><input type='text' size='3' value='10' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "<th  align='center'><span class='outputText2'><b>&nbsp;de&nbsp;</b></span></th>" +
                                "<th  align='center' class='ultCol'><input type='text' size='3' value='10' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "</tr>" +
                                "<tr>" +
                                "<th colspan='3'  align='center' rowspan='2'><span class='bold'><b>ESTERILIZACIÓN CALOR HUMEDO</b></span></th>" +
                                "<th  align='left'><span class='normal'>Lote</span></th>" +
                                "<th colspan='3' align='left' class='ultCol'><span class='normal'>"+(codLoteProduccion+(loteAsociado.equals("")?"":"<br>"+loteAsociado))+"</span></th>" +
                                "</tr><tr>" +
                                "<th  align='left'><span class='normal'>Expiración</span></th>" +
                                "<th  align='left' class='ultCol' colspan='3'>"+(fechaVencimiento.split("-").length>1?"<span class='normal'>"+fechaVencimiento+"</span>":"<input style='border:none' type='text' value='"+fechaVencimiento+"'/>")+"</th>" +
                                "</tr><tr>" +
                                "<th class='ultCol' colspan='9' style='padding:0 !important;font-size:3px;' align='left'>&nbsp;</th>" +
                                "</tr><tr>" +
                                "<th colspan='2' align='left'><span class='normal'>Nombre Comercial</span></th>" +
                                "<th colspan='3' align='center' ><span class='bold'><b>"+nombreProducto+"</b></span></th>" +
                                "<th  align='left'><span class='normal'>Presentación</span></th>" +
                                "<th colspan='3' class='ultCol' align='left'><span class='normal'>"+nombreEnvasePrimario+"</span></th>" +
                                "</tr><tr>" +
                                "<th colspan='2' rowspan='2'  align='left'><span class='normal'>Concentración</span></th>" +
                                "<th colspan='3' rowspan='2'  align='left'><span class='normal'>"+concentracion+"&nbsp;</span></th>" +
                                "<th  align='left'><span class='normal'>N° de Registro Sanitario</span></th>" +
                                "<th colspan='3' class='ultCol' align='left'><span class='normal'>"+registroSanitario+"</span></th>" +
                                "</tr><tr>" +
                                "<th  align='left'><span class='normal'>Vida util del producto</span></th>" +
                                "<th colspan='3' class='ultCol'  align='left'><span class='normal'>"+vidaUtil+" meses</span></th>" +
                                "</tr><tr>" +
                                "<th colspan='2'  align='left'><span class='normal'>Forma Farmaceútica</span></th>" +
                                "<th colspan='3'  align='left'><span class='normal'>"+nombreFormaFarmaceutica+"</span></th>" +
                                "<th  align='left'><span class='normal'>Tamaño de Lote Industrial</span></th>" +
                                "<th colspan='2'   align='left'><span class='normal'>"+tamLote+(loteAsociado.equals("")?"":"<br>"+cantAsociado)+"</span></th>" +
                                "<th align='left' class='ultCol'><span class='normal'>"+abreviaturaForma+"</span></th>" +
                                "</tr><tr><th class='ultCol' colspan='9' style='padding:0 !important;font-size:3px;'>&nbsp;</th></tr>" +
                                "<tr><th bgcolor='#cccccc' colspan='9' align='center' class='ultCol'><span class='bold' style='font-size:12px;'>DESPEJE DE LINEA ESTERILIZACION CALOR HUMEDO</span></th></tr>" +
                                "<tr><th colspan='9' align='left' class='ultCol'><span class='normal'>Realizar segun POE PRO-LES-IN-017 \"DESPEJE DE LINEA DE TRABAJO\"</span><br>" +
                                "<span class='normal'>Realizar el despeje de linea y solicitar al Jefe de area la aprobacion de la seccion de trabajo.</span>" +
                                "<br><br><span class='bold'>Aprobado por:</span><span class='normal'>"+personalDespeje+"</span></th></tr>"+
                                "<tr><th bgcolor='#cccccc' colspan='9' align='center' class='ultCol'><span class='bold' style='font-size:12px;'>ESTERILIZACIÓN CALOR HUMEDO</span></th></tr>" +
                                "<tr><th colspan='9' align='left' class='ultCol ultFil'><span class='bold'>Precauciones</span><br><span class='normal'>"+precaucionesCalorHumedo+"</span>" +
                                " <table width='80%' style='margin-top:0.2em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th bgcolor='#cccccc' align='center'><span class='bold'>Número de lote a esterilizar</span></th>" +
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Número de Bandejas de cada Lote</span></th></tr>"
                                );
                        if(!loteAsociado.equals(""))tamanoLote+=cantAsociado;
                        consulta="select sechla.cod_lote,sechla.CANTIDAD_BANDEJAS_LOTE"+
                                 " from SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTES_ADJUNTOS sechla " +
                                 " where sechla.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE='"+codSeguimiento+"' order by sechla.COD_LOTE";
                        res=st.executeQuery(consulta);
                        while(res.next())out.println("<tr><th><span class='normal'>"+res.getString("cod_lote")+"</span></th><th><span class='normal'>"+res.getInt("CANTIDAD_BANDEJAS_LOTE")+"</span></th></tr>");
                        out.println("</table><br><span class='normal'>"+indicacionesEsterilizacionCalor+"</span>" +
                                    "<table width='80%' style='margin-top:0.2em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >");
                                String cabeceraPersonal="";
                                String innerCabeceraPersonal="";
                                String detallePersonal="";
                                int contDetalle=0;
                                consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+'<br>'+p.NOMBRES_PERSONAL)as nombrePersonal"+
                                         " from SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE_ESPECIFICACIONES s inner join personal p on"+
                                         " p.COD_PERSONAL=s.COD_PERSONAL"+
                                         " where s.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE='"+codSeguimiento+"'"+
                                         " group by p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL"+
                                         " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL";
                                res=st.executeQuery(consulta);
                                while(res.next())
                                {
                                    innerCabeceraPersonal+="<th colspan='2' bgcolor='#cccccc' align='center' ><span class='bold'>"+res.getString("nombrePersonal")+"</span></th>";
                                    cabeceraPersonal+=",ISNULL(sechle"+res.getRow()+".CONFORME,0) as CONFORME"+res.getRow()+"," +
                                                      "ISNULL(sechle"+res.getRow()+".OBSERVACIONES,'') as OBSERVACIONES"+res.getRow();
                                    detallePersonal+=" left outer join SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE_ESPECIFICACIONES sechle"+res.getRow()+" on"+
                                                     " sechle"+res.getRow()+".COD_ESPECIFICACION_PROCESO = ep.COD_ESPECIFICACION_PROCESO and"+
                                                     " sechle"+res.getRow()+".COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE = '"+codSeguimiento+"'" +
                                                     " and sechle"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                                    contDetalle=res.getRow();
                                }
                        out.println("<tr><th bgcolor='#cccccc' rowspan='2'><span class='bold'>Mazden</span></th><th rowspan='2' colspan='2' bgcolor='#cccccc'><span class='bold'>Especificaciones<br>de la<br>Etapa</span></th>"+innerCabeceraPersonal+"</tr><tr>");
                        for(int i=1;i<=contDetalle;i++)out.println("<th bgcolor='#cccccc' ><span class='bold'>Conforme</span></th><th bgcolor='#cccccc'><span class='bold'>Observación</span></th>");
                        out.println("</tr>");
                        consulta=" select ep.NOMBRE_ESPECIFICACIONES_PROCESO,isnull(um.ABREVIATURA, 'N.A') as NOMBRE_UNIDAD_MEDIDA,"+
                                 " ep.COD_ESPECIFICACION_PROCESO,case when ep.ESPECIFICACION_STANDAR_FORMA=1 then ep.VALOR_EXACTO else rd.VALOR_EXACTO end as valorExacto"+
                                 " , case when ep.ESPECIFICACION_STANDAR_FORMA=1 THEN"+
                                 " ep.VALOR_TEXTO else rd.VALOR_TEXTO end as valorTexto,ep.RESULTADO_NUMERICO"+
                                 cabeceraPersonal+" from ESPECIFICACIONES_PROCESOS ep left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA ="+
                                 " ep.COD_UNIDAD_MEDIDA left outer join RECETAS_DESPIROGENIZADO rd on"+
                                 " rd.COD_ESPECIFICACION_PROCESO = ep.COD_ESPECIFICACION_PROCESO and rd.COD_RECETA = '"+codRecetaEsterilizacion+"'"+
                                 detallePersonal+" where ep.COD_FORMA = '"+codForma+"' and ep.COD_PROCESO_ORDEN_MANUFACTURA=4"+
                                 " order by ep.ORDEN";
                        System.out.println("consulta detalle materiales "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr>" +
                                        "<th><span class='normal'>"+res.getString("NOMBRE_ESPECIFICACIONES_PROCESO")+"</span></th>" +
                                        "<th "+(res.getString("NOMBRE_UNIDAD_MEDIDA").equals("N.A")?"colspan='2'":"")+"><span class='normal'>"+(res.getInt("RESULTADO_NUMERICO")>0?(res.getInt("valorExacto")>0?String.valueOf(res.getInt("valorExacto")):""):res.getString("valorTexto"))+"&nbsp;</span></th>"+
                                        (res.getString("NOMBRE_UNIDAD_MEDIDA").equals("N.A")?"":"<th><span class='normal'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></th>"));
                            for(int i=1;i<=contDetalle;i++)out.println("<th><span class='normal'>"+(res.getInt("CONFORME"+i)>0?"√":"&nbsp;")+"</span></th><th><span class='normal'>"+(res.getString("OBSERVACIONES"+i))+"&nbsp;</span></th>");
                            out.println("</tr>");
                            

                        }
                        out.println("</table></th></tr></table></div><div class='pagina'>" +
                                "<table width='80%' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th class='ultFil ultCol' align='left'>" +
                                "<span class='normal'>Si el indicador cambio de color coloque √, sino avise al responsable de area.</span><br>" +
                                "<table width='80%' style='margin-top:0.5em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th bgcolor='#cccccc'><span class='bold'>No de<br>Ampollas x<br>Recipiente</span></th>" +
                                "<th bgcolor='#cccccc'><span class='bold'>No de<br>Recipiente</span></th>" +
                                "<th bgcolor='#cccccc'><span class='bold'>Indicador</span></th>" +
                                "<th bgcolor='#cccccc'><span class='bold'>Obrero</span></th>" +
                                "<th bgcolor='#cccccc'><span class='bold'>Fecha</span></th>" +
                                "<th bgcolor='#cccccc'><span class='bold'>Hora<br>Inicio</span></th>" +
                                "<th bgcolor='#cccccc'><span class='bold'>Hora<br>Final</span></th>" +
                                "</tr>");
                        consulta="SELECT sechla.CANT_AMPOLLAS_RECIPIENTE,sechla.CANT_RECIPIENTES,sechla.INDICADOR,"+
                                  " isnull(sechla.COD_PERSONAL_OBRERO,sppp.COD_PERSONAL) as COD_PERSONAL,sppp.FECHA_INICIO,"+
                                  " sppp.FECHA_FINAL" +
                                  " ,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL)as nombrepersonal" +
                                  " FROM SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE_AMPOLLAS sechla"+
                                  " full outer join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on"+
                                  " sechla.COD_PERSONAL_OBRERO = sppp.COD_PERSONAL and"+
                                  " sechla.COD_REGISTRO_ORDEN_MANUFACTURA = sppp.COD_REGISTRO_ORDEN_MANUFACTURA" +
                                  " inner join personal p on p.COD_PERSONAL=sechla.COD_PERSONAL_OBRERO"+
                                  " where (sppp.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and sppp.COD_PROGRAMA_PROD = '"+codProgramaProd+"' and"+
                                  " sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadMazden+"' and"+
                                  " sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoprogramaProd+"' "+
                                  " and sechla.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE is null) or"+
                                  " (sechla.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE = '"+codSeguimiento+"'" +
                                  " and sppp.COD_LOTE_PRODUCCION is NULL) or"+
                                  " (sppp.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and sppp.COD_PROGRAMA_PROD = '"+codProgramaProd+"' and"+
                                  " sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadMazden+"' and"+
                                  " sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoprogramaProd+"'" +
                                  " and sechla.COD_SEGUIMIENTO_ESTERILIZACION_CALOR_HUMEDO_LOTE = "+codSeguimiento+")"+
                                  " order by sechla.COD_REGISTRO_ORDEN_MANUFACTURA";
                        System.out.println("consulta detalle seguimiento "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr>" +
                                    "<th><span class='normal'>"+res.getInt("CANT_AMPOLLAS_RECIPIENTE")+"</span></th>" +
                                    "<th><span class='normal'>"+res.getInt("CANT_RECIPIENTES")+"</span></th>" +
                                    "<th><span class='normal'>"+(res.getInt("INDICADOR")>0?"√":"&nbsp;")+"</span></th>" +
                                    "<th><span class='normal'>"+res.getString("nombrepersonal")+"</span></th>" +
                                    "<th><span class='normal'>"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"</span></th>" +
                                    "<th><span class='normal'>"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"</span></th>" +
                                    "<th><span class='normal'>"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"</span></th>" +
                                    "</tr>");
                        }
                        out.println("</table><br><span class='normal'>"+postIndicacionesEsterilizacionCalor+"</span><br><br><span class='bold'>NOMBRE DEL RESPONSABLE DE REPESADA:&nbsp;&nbsp;&nbsp;</span><span class='normal'>"+personalAprueba+"</span>" +
                                "<br><span class='bold'>Fecha:&nbsp;&nbsp;&nbsp;</span><span class='normal'>"+sdfDias.format(fechaCierre)+" "+sdfHoras.format(fechaCierre)+"</span>" +
                                "<br><br><span class='bold'>OBSERVACIONES:&nbsp;&nbsp;&nbsp;</span><br><span class='normal'>"+observacion+"</span>" +
                                "<br><br><br><br><br><br>" +
                                "</td></tr>");
                        res.close();
                        con.close();
                    
                    }catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
                %>
                
            </table>

        
</div>

    </body>
</html>
