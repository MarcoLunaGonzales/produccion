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
                int codSeguimiento=0;
                String observacion="";
                String personalDespeje="";
                int codActividadCambioFormato=0;
                int codActividadArmadoFiltros=0;
                int codActividadReguladoEquipo=0;
                String precaucionesDosificado="";
                String preIndicacionesDosificado="";
                String indicacionesDosificado="";
                String indicacionesAdicionalesDosificado="";
                boolean envasadoConGasNitrogeno=false;
                String codRecetaDosificado="";
                String personalApruebaSellado="";
                Date fechaApruebaSellado=new Date();
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
                                    "  isnull(dpff.CONDICIONES_GENERALES_REPESADA,'') as CONDICIONES_GENERALES_REPESADA"+
                                    " ,isnull(loteAsociado.loteAsociado,'') as loteAsociado,isnull(loteAsociado.cantAsociado,0) as cantAsociado" +
                                    " ,isnull(cpc.COD_RECETA_DOSIFICADO,0) as COD_RECETA_DOSIFICADO," +
                                    " isnull(cpc.COD_RECETA_DOSIFICADO, 0) as COD_RECETA_DOSIFICADO,"+
                                    " ISNULL(cpc.ENVASADO_CON_GAS_NITROGENO, 0) as ENVASADO_CON_GAS_NITROGENO,"+
                                    " ISNULL(dpff.PRECAUCIONES_DOSIFICADO, '') as PRECAUCIONES_DOSIFICADO,"+
                                    " isnull(dpff.PRE_INDICACIONES_DOSIFICADO, '') as PRE_INDICACIONES_DOSIFICADO,"+
                                    " isnull(dpff.INDICACIONES_DOSIFICADO, '') as INDICACIONES_DOSIFICADO,"+
                                    " isnull(cpc.INDICACION_ADICIONAL_DOSIFICADO, '') as INDICACION_ADICIONAL_DOSIFICADO,"+
                                    " isnull(cpc.INDICACION_ADICIONAL_DOSIFICADO,'') as INDICACION_ADICIONAL_DOSIFICADO," +
                                    " ISNULL(cpc.ENVASADO_CON_GAS_NITROGENO,0) as ENVASADO_CON_GAS_NITROGENO"+
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
                                    " left outer join DESCRIPCION_PROCESOS_FORMA_FARMACEUTICA dpff on dpff.COD_FORMA=cp.COD_FORMA" +
                                    " left outer join COMPONENTES_PROD_RECETA cpc on cpc.COD_COMPROD =pp.COD_COMPPROD"+
                                    " outer APPLY(select top 1 lpc.COD_LOTE_PRODUCCION_ASOCIADO as loteAsociado,pp1.CANT_LOTE_PRODUCCION as cantAsociado"+
                                    " from LOTES_PRODUCCION_CONJUNTA lpc inner join PROGRAMA_PRODUCCION pp1 on"+
                                    " lpc.COD_PROGRAMA_PROD=pp1.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION_ASOCIADO=pp1.COD_LOTE_PRODUCCION"+
                                    " where lpc.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION"+
                                    " and pp1.COD_COMPPROD=pp.COD_COMPPROD) loteAsociado"+
                                    " where pp.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and pp.cod_programa_prod='"+codProgramaProd+"' order by tpp.COD_TIPO_PROGRAMA_PROD,ppp.FECHA_FINAL desc";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);
                    
                    double tamanoLote=0d;
                    
                    String codFormulaMaestra="";
                    double cantidadVolumenEnvase=0d;
                    double toleranciaVolumen=0d;
                    String codTipoprogramaProd="";
                    String indicacionesRepesada="";
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat format = (DecimalFormat)nf;
                    format.applyPattern("#,##0.0");
                    NumberFormat nf2 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat formatNum = (DecimalFormat)nf2;
                    formatNum.applyPattern("###0.##");
                    if(res.next())
                    {
                        codRecetaDosificado=res.getString("COD_RECETA_DOSIFICADO");
                        indicacionesAdicionalesDosificado=res.getString("INDICACION_ADICIONAL_DOSIFICADO");
                        envasadoConGasNitrogeno=res.getInt("ENVASADO_CON_GAS_NITROGENO")>0;
                        codCompProd=res.getInt("COD_COMPPROD");
                        loteAsociado=res.getString("loteAsociado");
                        cantAsociado=res.getInt("cantAsociado");
                        vidaUtil=res.getInt("vida_util");
                        preIndicacionesDosificado=res.getString("PRE_INDICACIONES_DOSIFICADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        indicacionesDosificado=res.getString("INDICACIONES_DOSIFICADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
                        precaucionesDosificado=res.getString("PRECAUCIONES_DOSIFICADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>");
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
                           // codTipoprogramaProd+=","+res.getString("COD_TIPO_PROGRAMA_PROD");
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
                                "<th  align='center'><input type='text' size='3' value='6' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "<th  align='center'><span style='font-weight:normal'>&nbsp;de&nbsp;</span></th>" +
                                "<th  align='center' class='ultCol'><input type='text' size='3' value='10' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "</tr>" +
                                "<tr>" +
                                "<th colspan='3'  align='center' rowspan='2'><span class='bold'><b>PROCESO DE DOSIFICADO</b></span></th>" +
                                "<th  align='left'><span class='normal'>Lote</span></th>" +
                                "<th colspan='3' align='left' class='ultCol'><input type='text' size='10' value='"+(codLoteProduccion+(loteAsociado.equals("")?"":"<br>"+loteAsociado))+"' style='text-align:center;border:none;background-color:#ffffff'/></th>" +
                                "</tr><tr>" +
                                "<th  align='left'><span class='normal'>Expiración</span></th>" +
                                "<th  align='left' class='ultCol' colspan='3'><input type='text' size='10' value='"+fechaVencimiento+"' style='text-align:center;border:none;background-color:#ffffff'/></th>" +
                                "</tr><tr>" +
                                "<th class='ultCol' colspan='9' style='padding:0 ;font-size:6px' align='left'>&nbsp;</th>" +
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
                                "</tr><tr><th class='ultCol' colspan='9' style='padding:0;font-size:4px'>&nbsp;</th></tr>" +
                                "<tr><th bgcolor='#cccccc' colspan='9' align='center' class='ultCol'><span class='bold' style='font-size:12px;'>DESPEJE DE LINEA DE DOSIFICADO</span></th></tr>" +
                                "<tr><th colspan='9' align='left' class='ultCol'><span class='normal'>Realizar segun POE PRO-LES-IN-017 \"DESPEJE DE LINEA DE TRABAJO\"</span><br>" +
                                "<span class='normal'>Realizar el despeje de linea y solicitar al Jefe de area la aprobacion de la seccion de trabajo.</span>" +
                                "<br><br><span class='bold'>Aprobado por:</span><span class='normal'>........................................................................</span></th></tr>" +
                                "<tr><th class='ultCol' align='left' colspan='9'><span class='bold'>PRECAUCIONES:</span><span class='normal'>"+precaucionesDosificado+"<span></th></tr>"+
                                "<tr><th bgcolor='#cccccc' colspan='9' align='center' class='ultCol'><span class='bold' style='font-size:12px;'>PROCESO DE DOSIFICADO</span></th></tr>" +
                                "<tr><th colspan='9' align='left' class='ultCol ultFil'><span class='normal'>"+preIndicacionesDosificado+"</span>" +
                                " <table width='80%' style='margin-top:0.6em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >");
                       String cabeceraPersonal="";
                       String innerCabeceraPersonal="";
                       String detallePersonal="";
                       int contDetalle=0;
                      
                        out.println("<tr><th bgcolor='#cccccc' colspan='4' align='center' ><span class='bold'>ESPECIFICACIONES</span></th>"+
                                   " <th bgcolor='#cccccc' colspan='"+(5)+"' align='center'><span class='bold'>CONDICIONES DEL PROCESO</span></th>"+
                                   "</tr>"+
                                   " <tr><th bgcolor='#cccccc' rowspan='2' align='center'><span class='bold'>Poro del filtro</span></th>"+
                                   "<th bgcolor='#cccccc' rowspan='2' align='center' ><span class='bold'>Código de filtro</span></th>"+
                                   " <th bgcolor='#cccccc' rowspan='2' align='center'><span class='bold'>Presion de aprobación</span></th>"+
                                   " <th bgcolor='#cccccc' rowspan='2' align='center'><span class='bold'>Medio de Filtración</span></th>"+innerCabeceraPersonal+"</tr><tr>");
                        out.println("<th bgcolor='#cccccc' align='center'><span class='bold'>Prueba de Integridad<br>Positivo</span></th>"+
                                                               " <th bgcolor='#cccccc' colspan='2' align='center'><span class='bold'>Presión Registrada</span></th>"+
                                                               " <th bgcolor='#cccccc' colspan='2' align='center'><span class='bold'>Numero de filtros<br> utilizados</span></th>");
                        out.println("</tr>");
                        
                        if(!loteAsociado.equals(""))tamanoLote+=cantAsociado;
                        consulta="select fp.CANTIDAD_FILTRO,fp.COD_FILTRO_PRODUCCION,fp.COD_ESTADO_REGISTRO,fp.COD_MEDIO_FILTRACION,"+
                                         "mf.NOMBRE_MEDIO_FILTRACION,fp.COD_UNIDAD_MEDIDA,um.ABREVIATURA,fp.CODIGO_FILTRO_PRODUCCION,fp.PRESION_DE_APROBACION"+cabeceraPersonal+
                                         " ,isnull(um1.ABREVIATURA,'') as unidadPresion " +
                                         " from FILTROS_PRODUCCION fp inner join FILTROS_PRODUCCION_PRODUCTOS fpp on "+
                                         " fp.COD_FILTRO_PRODUCCION=fpp.COD_FILTRO_PRODUCCION inner join COMPONENTES_PROD cp on cp.COD_PROD=fpp.COD_PROD"+
                                         " inner join UNIDADES_MEDIDA um on fp.COD_UNIDAD_MEDIDA =um.COD_UNIDAD_MEDIDA and fp.COD_ESTADO_REGISTRO = 1"+
                                         " inner join MEDIOS_FILTRACION mf on mf.COD_MEDIO_FILTRACION =fp.COD_MEDIO_FILTRACION"+detallePersonal+
                                         " inner join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA =fp.COD_UNIDAD_MEDIDA_PRESION"+
                                         " WHERE cp.COD_COMPPROD='"+codCompProd+"'"+
                                         " order by fp.CODIGO_FILTRO_PRODUCCION";
                        System.out.println("consulta detalle filtros "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr><th  align='center'><span class='normal'>"+res.getString("CANTIDAD_FILTRO")+" "+res.getString("ABREVIATURA")+"</span></th>"+
                                        "<th  align='center'><span class='normal'>"+res.getString("CODIGO_FILTRO_PRODUCCION")+"</span></th>"+
                                        "<th  align='center'><span class='normal'>"+res.getString("PRESION_DE_APROBACION")+" "+res.getString("unidadPresion")+"</span></th>"+
                                        "<th  align='center'><span class='normal'>"+res.getString("NOMBRE_MEDIO_FILTRACION")+"</span></th>");
                            out.println("<th align='center'><span class='bold'>&nbsp;</span></th>" +
                                        "<th align='center'><span class='normal'>&nbsp;</span></th>"+
                                        "<th align='center'><span class='normal'>&nbsp;</span></th>"+
                                        " <th align='center'><span class='normal'>&nbsp;</span></th>"+
                                        " <th align='center'><span class='normal'>unid</span></th>");
                            out.println("</tr>");

                        }
                        out.println("</table><table width='80%' style='margin-top:0.6em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                    "<tr><th bgcolor='#cccccc' colspan='5'><span class='bold'>Cambio de Formato Envasadora</span></th></tr>" +
                                    "<tr><th bgcolor='#cccccc'><span class='bold'>Personal</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Fecha</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Hora<br>Inicio</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Hora<br>Final</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Horas<br>Hombre</span></th>" +
                                    "</tr>");
                        for(int i=0;i<2;i++)
                        {
                            out.println("<tr><th><span class='normal'>&nbsp;</span></th>" +
                                        "<th><span class='normal'>&nbsp;</span></th>" +
                                        "<th><span class='normal'>&nbsp;</span></th>" +
                                        "<th><span class='normal'>&nbsp;</span></th>" +
                                        "<th><span class='normal'>&nbsp;</span></th>" +
                                        " </tr>");
                        }
                        out.println("</table><table width='80%' style='margin-top:0.6em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                    "<tr><th bgcolor='#cccccc' colspan='5'><span class='bold'>Armado de Filtros,Bombas y envio de muestra de agua</span></th></tr>" +
                                    "<tr><th bgcolor='#cccccc'><span class='bold'>Personal</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Fecha</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Hora<br>Inicio</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Hora<br>Final</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Horas<br>Hombre</span></th>" +
                                    "</tr>");
                        for(int i=0;i<4;i++)
                        {
                            out.println("<tr><th><span class='normal'>&nbsp;</span></th>" +
                                        "<th><span class='normal'>&nbsp;</span></th>" +
                                        "<th><span class='normal'>&nbsp;</span></th>" +
                                        "<th><span class='normal'>&nbsp;</span></th>" +
                                        "<th><span class='normal'>&nbsp;</span></th>" +
                                        " </tr>");
                        }
                        out.println("</table></th></tr></table></div><div class='pagina'>" +
                                "</table><table width='80%' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th class='ultCol ultFil' align='left'><span class='normal'>"+indicacionesDosificado+"</span>" +(envasadoConGasNitrogeno?"<span class='bold'>"+(indicacionesAdicionalesDosificado.equals("")?"7. ENVASAR EL PRODUCTO CON GAS NITROGENO":indicacionesAdicionalesDosificado)+"</span>":"")+
                                "<table width='80%' style='margin-top:0.6em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >");
                        cabeceraPersonal="";
                        innerCabeceraPersonal="";
                        detallePersonal="";
                        contDetalle=0;
                        out.println("<tr><th bgcolor='#cccccc' align='center' colspan='3'><span class='bold'>ESPECIFICACIONES DE ETAPA DE DOSIFICADO</span></th>"+
                                    " <th bgcolor='#cccccc' align='center' colspan='2'><span class='bold'>CONDICCIONES DE ETAPA </span></th>"+
                                    "</tr><tr><th bgcolor='#cccccc' align='center' rowspan='2' ><span class='bold'>&nbsp;</span></th>"+
                                    "<th bgcolor='#cccccc' align='center' rowspan='2' ><span class='bold'>Valor</span></th>"+
                                    "<th bgcolor='#cccccc' align='center' rowspan='2' ><span class='bold'>Unidades</span></th>"+innerCabeceraPersonal+"</tr><tr>");
                        out.println("<th align='center' bgcolor='#cccccc' ><span class='bold'>Conforme</span></th><th bgcolor='#cccccc' align='center'><span class='bold'>Observación</span></th>");
                        out.println("</tr>");
                        consulta="select ep.RESULTADO_ESPERADO_LOTE,ep.COD_TIPO_ESPECIFICACION_PROCESO,ep.RESULTADO_NUMERICO,"+
                                 " ep.COD_ESPECIFICACION_PROCESO,ep.NOMBRE_ESPECIFICACIONES_PROCESO,"+
                                 " isnull(um.ABREVIATURA, 'N.A.') as ABREVIATURA"+cabeceraPersonal+
                                 " ,case when ep.ESPECIFICACION_STANDAR_FORMA = 1 then ep.VALOR_EXACTO"+
                                 " else rd.VALOR_EXACTO end as valorExacto,"+
                                 " case when ep.ESPECIFICACION_STANDAR_FORMA = 1 THEN ep.VALOR_TEXTO"+
                                 " else rd.VALOR_TEXTO end as valorTexto" +
                                 " ,ep.PORCIENTO_TOLERANCIA"+
                                 " from ESPECIFICACIONES_PROCESOS ep"+
                                 " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA =ep.COD_UNIDAD_MEDIDA"+
                                 " left outer join RECETAS_DESPIROGENIZADO rd on rd.COD_ESPECIFICACION_PROCESO"+
                                 " = ep.COD_ESPECIFICACION_PROCESO and rd.COD_RECETA = '"+codRecetaDosificado+"'"+detallePersonal+
                                 " where ep.COD_FORMA = '"+codForma+"' and ep.COD_PROCESO_ORDEN_MANUFACTURA = 3"+
                                 " order by ep.ORDEN";
                        System.out.println("consulta esp dos "+consulta);
                        res=st.executeQuery(consulta);
                        String resultado="";
                        double porcientoTolerancia=0;
                        while(res.next())
                        {
                            porcientoTolerancia=res.getInt("valorExacto")*res.getDouble("PORCIENTO_TOLERANCIA");
                            resultado=(res.getDouble("RESULTADO_NUMERICO")>0d?(res.getDouble("valorExacto")>0?formatNum.format(res.getDouble("valorExacto")-porcientoTolerancia)+(porcientoTolerancia>0?("-"+formatNum.format(res.getDouble("valorExacto")+porcientoTolerancia)):""):""):res.getString("valorTexto"));
                            out.println("<tr><th align='center'><span class='normal'>"+res.getString("NOMBRE_ESPECIFICACIONES_PROCESO")+"</span></th>"+
                                        "<th align='center'><span class='normal' >"+(resultado==null?"":resultado)+"</span></th>"+
                                        "<th align='center'><span class='normal' >"+res.getString("ABREVIATURA")+"</span></th>");
                            out.println("<th align='center'><span class='normal'>&nbsp;</span></th>"+
                                                                        "<th align='center'><span class='normal'>&nbsp;</span></th>");
                            out.println("</tr>");
                        }
                        out.println("</table><table width='80%' style='margin-top:0.6em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                    "<tr><th bgcolor='#cccccc' colspan='5'><span class='bold'>Regulado del equipo para aprobacion de volumen y altura</span></th></tr>" +
                                    "<tr><th bgcolor='#cccccc'><span class='bold'>Personal</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Fecha</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Hora<br>Inicio</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Hora<br>Final</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Horas<br>Hombre</span></th>" +
                                    "</tr>");
                        for(int i=0;i<4;i++)
                        {
                            out.println("<tr><th><span class='normal'>&nbsp</span></th>" +
                                        "<th><span class='normal'>&nbsp</span></th>" +
                                        "<th><span class='normal'>&nbsp</span></th>" +
                                        "<th><span class='normal'>&nbsp</span></th>" +
                                        "<th><span class='normal'>&nbsp</span></th>" +
                                        " </tr>");
                        }
                       out.println("</table><span class='normal'><br>"+(envasadoConGasNitrogeno?"8":"7")+".Una vez termine la dosificación de ampollas, dejar pasar 5 litros de agua purificada y realizar punto burbuja"+
                                   "unicamente cuando se trate de filtros de cartucho.</span>" +
                                   "<table width='60%' style='margin-top:0.6em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                    "<tr><th style='border:none' ><span class='bold'>Personal que aprueba el volumen y la altura del sellado:</span></th>" +
                                    "<th style='border-bottom:none' ><span class='normal'>............................</span></th></tr>" +
                                    "<tr><th style='border-right:none'><span class='bold'>Hora</span></th>" +
                                    "<th><span class='normal'>..........:.............</span></th></tr></table>" +
                                    "</th></tr></table></div><div class='pagina'>"+
                                    "<table width='80%'  align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                    "<tr><th class='ultCol ultFil'align ='left'><table width='60%' style='margin-top:0.6em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" );
                       cabeceraPersonal="";
                       innerCabeceraPersonal="";
                       detallePersonal="";
                       contDetalle=0;
                        out.println("<tr><th bgcolor='#cccccc' rowspan='2'align='center' ><span class='bold'>Porosidad de membrana</span></th>"+innerCabeceraPersonal+"</tr><tr>");
                        out.println("<th bgcolor='#cccccc' align='center'><span class='bold'>Prueba de integridad Positivo</span></th>"+
                                                                   " <th bgcolor='#cccccc' colspan='2' align='center' ><span class='bold'>Presión<br>Registrada</span></th>"+
                                                                  " <th bgcolor='#cccccc' align='center'><span class='bold'>Observaciones</span></th>");
                        out.println("</tr>");
                        consulta="select fp.CODIGO_FILTRO_PRODUCCION,fp.COD_FILTRO_PRODUCCION,um.ABREVIATURA"+cabeceraPersonal+
                                     ",um1.ABREVIATURA as abreviaturaPresion"+
                                     " from FILTROS_PRODUCCION fp inner join FILTROS_PRODUCCION_PRODUCTOS fpp on "+
                                     " fp.COD_FILTRO_PRODUCCION=fpp.COD_FILTRO_PRODUCCION inner join COMPONENTES_PROD cp on cp.COD_PROD=fpp.COD_PROD"+
                                     " inner join UNIDADES_MEDIDA um on fp.COD_UNIDAD_MEDIDA = um.COD_UNIDAD_MEDIDA and fp.cod_estado_registro = 1"+
                                     " inner join MEDIOS_FILTRACION mf on mf.COD_MEDIO_FILTRACION =fp.COD_MEDIO_FILTRACION"+detallePersonal+
                                     " left outer join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA =fp.COD_UNIDAD_MEDIDA_PRESION"+
                                     " where cp.COD_COMPPROD='"+codCompProd+"' order by fp.CODIGO_FILTRO_PRODUCCION";
                       System.out.println("consulta post filtrado "+consulta);
                       res=st.executeQuery(consulta);
                       while(res.next())
                       {
                            out.println("<tr ><th align='center'><span class='normal'>"+res.getString("CODIGO_FILTRO_PRODUCCION")+" "+res.getString("ABREVIATURA")+"&nbsp;</span></th>");
                            out.println("<th align='center'><span class='bold'>&nbsp;</span></th>"+
                                        "<th colspan='2' align='center'><span class='normal'> &nbsp;</span></th>"+
                                        " <th align='center'><span class='normal' >&nbsp;</span></th>");
                                   
                               out.println("</tr>");
                       }
                       out.println("</table><br><br><span class='bold'>NOMBRE DEL SUPERVISOR:&nbsp;&nbsp;&nbsp;</span><span class='normal'>...................................................................</span>" +
                                  "<br><span class='bold'>Fecha:&nbsp;&nbsp;&nbsp;</span><span class='normal'>........./....../..................</span>" +
                                "<br><br><span class='bold'>OBSERVACIONES:&nbsp;&nbsp;&nbsp;</span><br><span class='normal'>.............................................................................................................................</span>" +
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
