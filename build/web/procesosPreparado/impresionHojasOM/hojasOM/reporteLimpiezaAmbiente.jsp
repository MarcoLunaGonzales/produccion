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
                String indicacionesLimpiezaAmbiente="";
                String indicacionesEsterilizacion="";
                String indicacionesLimpiezaEquipos="";
                int codActividadEsterilizacionFiltro=0;
                int codActividadEsterilizacionUtensilios=0;
                int codActividadAutoclave=0;
                int codActividadDosificado=0;
                int codActividadLavadoAmp=0;
                int codActividadPreparado=0;
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
                                    "  isnull(dpff.INDICACIONES_ESTERILIZACION_UTENSILIOS, '') as INDICACIONES_ESTERILIZACION_UTENSILIOS,"+
                                    " isnull(dpff.INDICACIONES_LIMPIEZA_AMBIENTE, '') as   INDICACIONES_LIMPIEZA_AMBIENTE,"+
                                    " isnull(dpff.INDICACIONES_LIMPIEZA_EQUIPOS, '') as INDICACIONES_LIMPIEZA_EQUIPOS"+
                                    " ,sll.COD_SEGUIMIENTO_LIMPIEZA_LOTE,sll.FECHA_CIERRE"+
                                    " ,(per.AP_PATERNO_PERSONAL+' '+per.AP_MATERNO_PERSONAL+' '+per.NOMBRES_PERSONAL+' '+per.nombre2_personal) as nombrePersonal" +
                                    " ,isnull(loteAsociado.loteAsociado,'') as loteAsociado,isnull(loteAsociado.cantAsociado,0) as cantAsociado" +
                                    " ,sll.OBSERVACIONES,isnull(afm.COD_ACTIVIDAD_FORMULA, 0) as codActividadAutoclave,"+
                                    "   isnull(afm1.COD_ACTIVIDAD_FORMULA, 0) as codActividadDosificado,"+
                                    "   ISNULL(afm2.COD_ACTIVIDAD_FORMULA, 0) as codActividadLavadoAmpollas,"+
                                    "   isnull(afm3.COD_ACTIVIDAD_FORMULA, 0) as codActividaPreparado,"+
                                    "   isnull(afm4.COD_ACTIVIDAD_FORMULA, 0) as codActividaEsterilizacionUtensilios,"+
                                    "   isnull(afm5.COD_ACTIVIDAD_FORMULA, 0) as codActividaEsterilizacionFiltros"+
                                    "  ,isnull(afm6.COD_ACTIVIDAD_FORMULA,0) as codActividadaLavadoFrascos" +
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
                                    " inner join SEGUIMIENTO_LIMPIEZA_LOTE sll on sll.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD"+
                                    " and sll.COD_LOTE=pp.COD_LOTE_PRODUCCION"+
                                    " inner join personal per on per.COD_PERSONAL=sll.COD_PERSONAL_SUPERVISOR" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA ="+
                                    " 96 and afm.COD_ACTIVIDAD = 95 and afm.COD_FORMULA_MAESTRA ="+
                                    " pp.COD_FORMULA_MAESTRA and afm.COD_PRESENTACION = 0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm1 on afm1.COD_AREA_EMPRESA ="+
                                    " 96 and afm1.COD_ACTIVIDAD = 88 and afm1.COD_FORMULA_MAESTRA ="+
                                    " pp.COD_FORMULA_MAESTRA and afm1.COD_PRESENTACION = 0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm2 on afm2.COD_AREA_EMPRESA ="+
                                    " 96 and afm2.COD_ACTIVIDAD in (94) and afm2.COD_FORMULA_MAESTRA ="+
                                    " pp.COD_FORMULA_MAESTRA and afm2.COD_PRESENTACION = 0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm3 on afm3.COD_AREA_EMPRESA ="+
                                    " 96 and afm3.COD_ACTIVIDAD = 2 and afm3.COD_FORMULA_MAESTRA ="+
                                    " pp.COD_FORMULA_MAESTRA and afm3.COD_PRESENTACION = 0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm4 on afm4.COD_AREA_EMPRESA ="+
                                    " 96 and afm4.COD_ACTIVIDAD = 261 and afm4.COD_FORMULA_MAESTRA ="+
                                    " pp.COD_FORMULA_MAESTRA and afm4.COD_PRESENTACION = 0"+
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm5 on afm5.COD_AREA_EMPRESA ="+
                                    " 96 and afm5.COD_ACTIVIDAD = 260 and afm5.COD_FORMULA_MAESTRA ="+
                                    " pp.COD_FORMULA_MAESTRA and afm5.COD_PRESENTACION = 0" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm6 on afm6.COD_AREA_EMPRESA ="+
                                    " 96 and afm6.COD_ACTIVIDAD = 60 and afm6.COD_FORMULA_MAESTRA =pp.COD_FORMULA_MAESTRA and afm6.COD_PRESENTACION=0" +
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
                    
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat format = (DecimalFormat)nf;
                    format.applyPattern("#,##0.0");
                    if(res.next())
                    {
						codForma=res.getInt("cod_forma");
                        codActividadAutoclave=res.getInt("codActividadAutoclave");
                        codActividadDosificado=res.getInt("codActividadDosificado");
						codActividadLavadoAmp=(codForma==2?res.getInt("codActividadLavadoAmpollas"):res.getInt("codActividadaLavadoFrascos"));
                        codActividadPreparado=res.getInt("codActividaPreparado");
                        codActividadEsterilizacionUtensilios=res.getInt("codActividaEsterilizacionUtensilios");
                        codActividadEsterilizacionFiltro=res.getInt("codActividaEsterilizacionFiltros");
                        observacion=res.getString("OBSERVACIONES");
                        codSeguimiento=res.getInt("COD_SEGUIMIENTO_LIMPIEZA_LOTE");
                        fechaCierre=res.getTimestamp("FECHA_CIERRE");
                        personalAprueba=res.getString("nombrePersonal");
                        codCompProd=res.getInt("COD_COMPPROD");
                        loteAsociado=res.getString("loteAsociado");
                        cantAsociado=res.getInt("cantAsociado");
                        vidaUtil=res.getInt("vida_util");
                        indicacionesLimpiezaAmbiente=res.getString("INDICACIONES_LIMPIEZA_AMBIENTE").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        indicacionesEsterilizacion=res.getString("INDICACIONES_ESTERILIZACION_UTENSILIOS").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
                        indicacionesLimpiezaEquipos=res.getString("INDICACIONES_LIMPIEZA_EQUIPOS").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
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
                        if(res.getString("cod_forma").equals("2"))
                        {
                            consulta="select FECHA_VENCIMIENTO from INGRESOS_ALMACEN_DETALLE_ESTADO i inner join FORMULA_MAESTRA_DETALLE_EP_version fmdep on fmdep.COD_MATERIAL = i.COD_MATERIAL" +
                            " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA = fmdep.COD_FORMULA_MAESTRA inner join COMPONENTES_PROD cp on cp.COD_COMPPROD = fm.COD_COMPPROD " +
                            " where i.LOTE_MATERIAL_PROVEEDOR = '"+codLoteProduccion+"' ";
                            System.out.println("consulta fecha material "+consulta);
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
                                "<th  align='center'><input type='text' size='3' value='1' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "<th  align='center'><span style='font-weight:normal'>&nbsp;de&nbsp;</span></th>" +
                                "<th  align='center' class='ultCol'><input type='text' size='1' value='10' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "</tr>" +
                                "<tr>" +
                                "<th colspan='3'  align='center' rowspan='2'><span class='bold'><b>DESPEJE DE LINEA<br>LIMPIEZA DE AMBIENTES</b></span></th>" +
                                "<th  align='left'><span class='normal'>Lote</span></th>" +
                                "<th colspan='3' align='left' class='ultCol'><span class='normal'>"+(codLoteProduccion+(loteAsociado.equals("")?"":"<br>"+loteAsociado))+"</span></th>" +
                                "</tr><tr>" +
                                "<th  align='left'><span class='normal'>Expiración</span></th>" +
                                "<th  align='left' class='ultCol' colspan='3'>"+(fechaVencimiento.split("-").length>1?"<span class='normal'>"+fechaVencimiento+"</span>":"<input style='border:none' type='text' value='"+fechaVencimiento+"'/>")+"</th>" +
                                "</tr><tr>" +
                                "<th class='ultCol' colspan='9'  align='left'>&nbsp;</th>" +
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
                                "</tr><tr><th class='ultCol' colspan='9'>&nbsp;</th></tr>" +
                                "<tr><th bgcolor='#cccccc' colspan='9' align='center' class='ultCol'><span class='bold' style='font-size:12px;'>REGISTRO DE LIMPIEZA DE AMBIENTES</span></th></tr>" +
                                "<tr><th colspan='9' align='left' class='ultCol'><span class='normal'>"+indicacionesLimpiezaAmbiente+"</span>" +
                                " <table width='80%' style='margin-top:0.6em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th bgcolor='#cccccc' rowspan='3' align='center'><span class='bold'>SECCION</span></th>" +
                                "<th bgcolor='#cccccc' rowspan='3' align='center'><span class='bold'>RESPONSABLE DE LIMPIEZA</span></th>"+
                                "<th bgcolor='#cccccc' colspan='3' align='center'><span class='bold'>TIPO DE LIMPIEZA</span></th>"+
                                "<th bgcolor='#cccccc' rowspan='3' align='center'><span class='bold'>FECHA</span></th>"+
                                "<th bgcolor='#cccccc' rowspan='3' align='center'><span class='bold'>HORA<BR>INICIO</span></th>"+
                                "<th bgcolor='#cccccc' rowspan='3' align='center'><span class='bold'>HORA<BR>FINAL</span></th></tr><tr>" +
                                "<th bgcolor='#cccccc' rowspan='2'  align='center'><span class='bold'>Sanitizante</span></th>"+
                                "<th bgcolor='#cccccc' colspan='2'  align='center'><span class='bold'>Limpieza</span></th>"+
                                "</tr><tr>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>Radical</span></th>"+
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Ordinaria</span></th>"+
                                "</tr>");
                        if(!loteAsociado.equals(""))tamanoLote+=cantAsociado;
                        consulta="select som.NOMBRE_SECCION_ORDEN_MANUFACTURA,"+
                             " isnull(slls.COD_PERSONAL_LIMPIEZA,0) as COD_PERSONAL_LIMPIEZA,"+
                             " ISNULL(slls.LIMPIEZA_RADICAL,0) as LIMPIEZA_RADICAL,isnull(slls.LIMPIEZA_ORDINARIA,0) as LIMPIEZA_ORDINARIA,"+
                             " sppp.FECHA_INICIO,sppp.FECHA_FINAL,isnull(slls.COD_SANITIZANTE_LIMPIEZA,0) as COD_SANITIZANTE_LIMPIEZA,slls.REGISTRO_PRINCIPAL" +
                             " ,isnull((p.AP_MATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL)) as nombrePersonal,"+
                            " sl.NOMBRE_SANITIZANTE_LIMPIEZA"+
                            " from SECCIONES_ORDEN_MANUFACTURA som left outer join"+
                            " SEGUIMIENTO_LIMPIEZA_LOTE_SECCIONES slls on som.COD_SECCION_ORDEN_MANUFACTURA"+
                            " =slls.COD_SECCION_ORDEN_MANUFACTURA and slls.COD_SEGUIMIENTO_LIMPIEZA_LOTE='"+codSeguimiento+"'" +
                            " left outer join personal p on p.COD_PERSONAL=slls.COD_PERSONAL_LIMPIEZA"+
                            " left outer join personal_temporal pt on pt.COD_PERSONAL=slls.COD_PERSONAL_LIMPIEZA"+
                            " inner join SANITIZANTES_LIMPIEZA sl on sl.COD_SANITIZANTE_LIMPIEZA=slls.COD_SANITIZANTE_LIMPIEZA" +
                            "  left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on"+
                            " sppp.COD_REGISTRO_ORDEN_MANUFACTURA=slls.COD_REGISTRO_ORDEN_MANUFACTURA"+
                            " and sppp.COD_PERSONAL=slls.COD_PERSONAL_LIMPIEZA"+
                            " and sppp.COD_LOTE_PRODUCCION='"+codLoteProduccion+"'"+
                            " and sppp.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                            " and sppp.COD_COMPPROD='"+codCompProd+"'"+
                            " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                            " and sppp.COD_TIPO_PROGRAMA_PROD in ("+codTipoprogramaProd+")" +
                            " and sppp.COD_ACTIVIDAD_PROGRAMA=(case"+
                            " when slls.COD_SECCION_ORDEN_MANUFACTURA=1 then "+codActividadLavadoAmp+
                            " when slls.COD_SECCION_ORDEN_MANUFACTURA=2 then "+codActividadPreparado+
                            " when slls.COD_SECCION_ORDEN_MANUFACTURA=3 then "+codActividadDosificado+
                            " when slls.COD_SECCION_ORDEN_MANUFACTURA=4 then "+codActividadAutoclave+
                            " else 0 end)" +
                            " where som.COD_ESTADO_REGISTRO=1"+
                            " and som.COD_SECCION_ORDEN_MANUFACTURA in ( select m.COD_SECCION_ORDEN_MANUFACTURA from COMPONENTES_PROD_MAQUINARIA_LIMPIEZA c inner join MAQUINARIAS m"+
                            " on m.COD_MAQUINA=c.COD_MAQUINA where c.COD_COMPPROD='"+codCompProd+"')"+
                            " order by som.NOMBRE_SECCION_ORDEN_MANUFACTURA";
                        System.out.println("consulta detalle secciones "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr><th><span class='normal'>"+res.getString("NOMBRE_SECCION_ORDEN_MANUFACTURA")+"</span></th>" +
                                        "<th><span class='normal'>"+res.getString("nombrePersonal")+"</span></th>"+
                                        "<th><span class='normal'>"+res.getString("NOMBRE_SANITIZANTE_LIMPIEZA")+"</span></th>"+
                                        "<th><span class='normal'>"+(res.getInt("LIMPIEZA_RADICAL")>0?"√":"&nbsp;")+"</span></th>"+
                                        "<th><span class='normal'>"+(res.getInt("LIMPIEZA_ORDINARIA")>0?"√":"&nbsp;")+"</span></th>"+
                                        "<th><span class='normal'>"+(res.getTimestamp("FECHA_INICIO")!=null?(sdfDias.format(res.getTimestamp("FECHA_INICIO"))):"")+"</span></th>"+
                                        "<th><span class='normal'>"+(res.getTimestamp("FECHA_INICIO")!=null?(sdfHoras.format(res.getTimestamp("FECHA_INICIO"))):"")+"</span></th>"+
                                        "<th align='center'><span class='normal'>"+(res.getTimestamp("FECHA_FINAL")!=null?(sdfHoras.format(res.getTimestamp("FECHA_FINAL"))):"")+"</span></th></tr>");//"+(res.getInt("PESADA_CORRECTAMENTE")>0?"√":"&nbsp;")+"
                            

                        }
                        out.println("</table></th></tr><tr><th bgcolor='#cccccc' colspan='9' align='center' class='ultCol '><span class='bold' style='font-size:12px;'>REGISTRO DE LIMPIEZA DE EQUIPOS(Control de Limpieza)</span></th></tr>" +
                                "<tr><th colspan='9' align='left' class='ultCol ultFil'><span class='normal'>"+indicacionesLimpiezaEquipos+"</span></th></tr></table></div><div class='pagina'>" +
                                " <table width='80%' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th class='ultCol'>" +
                                "<table width='80%' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th bgcolor='#cccccc' rowspan='3' align='center'><span class='bold'>EQUIPO(SECCION)</span></th>" +
                                "<th bgcolor='#cccccc' rowspan='3' align='center'><span class='bold'>RESPONSABLE DE LIMPIEZA</span></th>"+
                                "<th bgcolor='#cccccc' colspan='3' align='center'><span class='bold'>TIPO DE LIMPIEZA</span></th>"+
                                "<th bgcolor='#cccccc' rowspan='3' align='center'><span class='bold'>FECHA</span></th>"+
                                "<th bgcolor='#cccccc' rowspan='3' align='center'><span class='bold'>HORA<BR>INICIO</span></th>"+
                                "<th bgcolor='#cccccc' rowspan='3' align='center'><span class='bold'>HORA<BR>FINAL</span></th></tr><tr>" +
                                "<th bgcolor='#cccccc' rowspan='2'  align='center'><span class='bold'>Sanitizante</span></th>"+
                                "<th bgcolor='#cccccc' colspan='2'  align='center'><span class='bold'>Limpieza</span></th>"+
                                "</tr><tr>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>Radical</span></th>"+
                                "<th bgcolor='#cccccc' align='center'><span class='bold'>Ordinaria</span></th>"+
                                "</tr>");
                        consulta="SELECT m.COD_SECCION_ORDEN_MANUFACTURA,m.NOMBRE_MAQUINA,m.COD_MAQUINA,m.CODIGO,"+
                                 " isnull(slle.COD_PERSONAL_RESPONSABLE_LIMPIEZA,0) as COD_PERSONAL_RESPONSABLE_LIMPIEZA"+
                                 " ,isnull(slle.LIMPIEZA_ORDINARIA,0) as LIMPIEZA_ORDINARIA,"+
                                 " isnull(slle.LIMPIEZA_RADICAL,0) as LIMPIEZA_RADICAL" +
                                 " ,isnull(slle.COD_SANITIZANTE_LIMPIEZA,0) as COD_SANITIZANTE_LIMPIEZA" +
                                 " ,sppp.FECHA_INICIO,sppp.FECHA_FINAL,slle.REGISTRO_PRINCIPAL" +
                                 " ,isnull((p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL))as nombrePersona,"+
                                 " sl.NOMBRE_SANITIZANTE_LIMPIEZA"+
                                 " FROM COMPONENTES_PROD_MAQUINARIA_LIMPIEZA cpml inner join MAQUINARIAS m"+
                                 "  on cpml.COD_MAQUINA=m.COD_MAQUINA"+
                                 " inner join SEGUIMIENTO_LIMPIEZA_LOTE_EQUIPOS slle on "+
                                 " slle.COD_MAQUINA=m.COD_MAQUINA and slle.COD_SEGUIMIENTO_LIMPIEZA_LOTE='"+codSeguimiento+"'" +
                                 " inner join SANITIZANTES_LIMPIEZA sl on sl.COD_SANITIZANTE_LIMPIEZA=slle.COD_SANITIZANTE_LIMPIEZA"+
                                 " left outer join personal p on p.COD_PERSONAL=slle.COD_PERSONAL_RESPONSABLE_LIMPIEZA" +
								 " left outer join personal_temporal pt on pt.COD_PERSONAL=slle.COD_PERSONAL_RESPONSABLE_LIMPIEZA" +
                                 " left outer join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on "+
                                 " sppp.COD_REGISTRO_ORDEN_MANUFACTURA=slle.COD_REGISTRO_ORDEN_MANUFACTURA"+
                                 " and sppp.COD_PERSONAL=slle.COD_PERSONAL_RESPONSABLE_LIMPIEZA"+
                                 " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                                 " and sppp.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                                 " and sppp.COD_LOTE_PRODUCCION='"+codLoteProduccion+"'"+
                                 " and sppp.COD_TIPO_PROGRAMA_PROD in ("+codTipoprogramaProd+")"+
                                 " and sppp.COD_COMPPROD='"+codCompProd+"'"+
                                 " and sppp.COD_ACTIVIDAD_PROGRAMA=(case"+
                                 " when m.COD_SECCION_ORDEN_MANUFACTURA=1 then "+codActividadLavadoAmp+
                                 " when m.COD_SECCION_ORDEN_MANUFACTURA=2 then "+codActividadPreparado+
                                 " when m.COD_SECCION_ORDEN_MANUFACTURA=3 then "+codActividadDosificado+
                                 " when m.COD_SECCION_ORDEN_MANUFACTURA=4 then "+codActividadAutoclave+
                                 " when m.COD_SECCION_ORDEN_MANUFACTURA=5 then "+codActividadDosificado+
                                 " else 0 end )"+
                                 " where m.COD_TIPO_EQUIPO=2 and cpml.COD_COMPPROD='"+codCompProd+"' "+
                                 " order by case when slle.REGISTRO_PRINCIPAL=1 then 1 else 2 end, m.NOMBRE_MAQUINA";
                        System.out.println("consulta maquinarias "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr>" +
                                        "<th><span class='normal'>"+res.getString("NOMBRE_MAQUINA")+"</span></th>" +
                                        "<th><span class='normal'>"+res.getString("nombrePersona")+"</span></th>" +
                                        "<th><span class='normal'>"+res.getString("NOMBRE_SANITIZANTE_LIMPIEZA")+"</span></th>" +
                                        "<th><span class='normal'>"+(res.getInt("LIMPIEZA_RADICAL")>0?"√":"&nbsp;")+"</span></th>"+
                                        "<th><span class='normal'>"+(res.getInt("LIMPIEZA_ORDINARIA")>0?"√":"&nbsp;")+"</span></th>"+
                                        "<th><span class='normal'>"+(res.getTimestamp("FECHA_INICIO")!=null?(sdfDias.format(res.getTimestamp("FECHA_INICIO"))):"")+"</span></th>"+
                                        "<th><span class='normal'>"+(res.getTimestamp("FECHA_INICIO")!=null?(sdfHoras.format(res.getTimestamp("FECHA_INICIO"))):"")+"</span></th>"+
                                        "<th align='center'><span class='normal'>"+(res.getTimestamp("FECHA_INICIO")!=null?(sdfHoras.format(res.getTimestamp("FECHA_FINAL"))):"")+"</span></th></tr>");
                        }
                       out.println("</table></th></tr>" +
                               "<tr><th bgcolor='#cccccc' colspan='9' align='center' class='ultCol'><span class='bold' style='font-size:12px;'>REGISTRO DE LIMPIEZA Y ESTERILIZACION DE UTENSILIOS</span></th></tr>" +
                                "<tr><th colspan='9' align='left' class='ultCol ultFil'><span class='normal'>"+indicacionesEsterilizacion+"</span>" +
                                "<table width='80%' style='margin-top:0.5em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th bgcolor='#cccccc' colspan='5'><span class='bold'>Responsable de Esterilización de Utensilios</span></th><tr>" +
                                "<tr>" +
                                "<th bgcolor='#cccccc'><span class='bold'>Personal</span></th>" +
                                "<th bgcolor='#cccccc'><span class='bold'>Fecha</span></th>" +
                                "<th bgcolor='#cccccc'><span class='bold'>Hora Inicio</span></th>" +
                                "<th bgcolor='#cccccc'><span class='bold'>Hora Final</span></th>" +
                                "<th bgcolor='#cccccc'><span class='bold'>Horas Hombre</span></th>" +
                                "<tr>" );
                       consulta="select sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE,isnull((p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL))as nombrePersona "+
                                " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp"+
                                " left outer join  personal p on p.cod_personal=sppp.cod_personal "+
                                " left outer join  personal_temporal pt on pt.cod_personal=sppp.cod_personal "+
                                " where sppp.COD_PROGRAMA_PROD='"+codProgramaProd+"' and sppp.COD_LOTE_PRODUCCION='"+codLoteProduccion+"'"+
                                " and sppp.COD_COMPPROD='"+codCompProd+"' and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadEsterilizacionUtensilios+"'"+
                                " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and sppp.COD_TIPO_PROGRAMA_PROD in("+codTipoprogramaProd+")" +
                                " order by sppp.FECHA_INICIO";
                       System.out.println("consulta personal esterilizacion utensilio"+consulta );
                       res=st.executeQuery(consulta);
                       while(res.next())
                       {
                           out.println("<tr>" +
                                        "<th><span class='normal'>"+res.getString("nombrePersona")+"</span></th>" +
                                        "<th><span class='normal'>"+(sdfDias.format(res.getTimestamp("FECHA_INICIO")))+"</span></th>"+
                                        "<th><span class='normal'>"+(sdfHoras.format(res.getTimestamp("FECHA_INICIO")))+"</span></th>"+
                                        "<th align='center'><span class='normal'>"+(sdfHoras.format(res.getTimestamp("FECHA_FINAL")))+"</span></th>" +
                                        "<th><span class='normal'>"+res.getString("HORAS_HOMBRE")+"</span></th>" +
                                        "</tr>");
                       }
                      out.println("</table>"+
                                  "<table width='80%' style='margin-top:0.6em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >");
                      String cabeceraPersonal="";
                       String innerCabeceraPersonal="";
                       String detallePersonal="";
                       int contDetalle=0;
                       consulta="select s.COD_PERSONAL,isnull((p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+'<br>'+p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+'<br>'+pt.NOMBRES_PERSONAL))as nombrePersonal"+
                                 " from SEGUIMIENTO_LIMPIEZA_LOTE_UTENSILIOS s"+
							     " left outer join personal p on s.COD_PERSONAL=p.COD_PERSONAL"+
								 " left outer join personal_temporal pt on s.COD_PERSONAL=pt.COD_PERSONAL"+
                                 " where s.COD_SEGUIMIENTO_LIMPIEZA_LOTE='"+codSeguimiento+"'"+
                                 " group by s.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL ,pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL"+
                                 " order by 2";
                        System.out.println("consulta personal Registrado "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            innerCabeceraPersonal+="<th bgcolor='#cccccc' ><span class='bold'>"+res.getString("nombrePersonal")+"</span></td>";
                            cabeceraPersonal+=",ISNULL(sedl"+res.getRow()+".COD_MAQUINA,0) as registrado"+res.getRow();
                            detallePersonal+=" left outer join SEGUIMIENTO_LIMPIEZA_LOTE_UTENSILIOS sedl"+res.getRow()+" on"+
                                             " sedl"+res.getRow()+".COD_MAQUINA = m.COD_MAQUINA and"+
                                             " sedl"+res.getRow()+".COD_SEGUIMIENTO_LIMPIEZA_LOTE = '"+codSeguimiento+"'" +
                                             " and sedl"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                            contDetalle=res.getRow();
                        }
                        out.println("<tr>" +
                                    "<th colspan='"+contDetalle+"' bgcolor='#cccccc'><span class='bold'>UTENSILIO LIMPIADO</span></th>" +
                                    "<th rowspan='2' bgcolor='#cccccc'><span class='bold'>UTENSILIO</span></th>" +
                                    "<th rowspan='2' bgcolor='#cccccc'><span class='bold'>CODIGO</span></th>" +
                                    "</tr><tr>"+innerCabeceraPersonal+"</tr>");
                        consulta="SELECT m.NOMBRE_MAQUINA,m.COD_MAQUINA,m.CODIGO"+cabeceraPersonal+
                                " FROM COMPONENTES_PROD_MAQUINARIA_LIMPIEZA cpml"+
                                " inner join MAQUINARIAS m on cpml.COD_MAQUINA = m.COD_MAQUINA" +detallePersonal+
                                " where m.COD_TIPO_EQUIPO=8 and  cpml.COD_COMPPROD = '"+codCompProd+"' order by m.NOMBRE_MAQUINA ";
                        System.out.println("consulta detalla utensilios limpiados "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr>");
                            for(int i=1;i<=contDetalle;i++)out.println("<th><span class='bold'>"+(res.getInt("registrado"+i)>0?"√":"&nbsp;")+"</span></th>");
                            out.println("<th><span class='normal'>"+res.getString("NOMBRE_MAQUINA")+"&nbsp;</span></th><th><span class='normal'>"+res.getString("CODIGO")+"&nbsp;</span></th></tr>");
                        }
                        out.println("</table></th></tr></table></div><div class='pagina'>" +
                                    "<table width='80%' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                    "<tr><th class='ultFil ultCol' align='left'>"+
                                    "<table width='80%' style='margin-top:0.5em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                    "<tr><th bgcolor='#cccccc' colspan='5'><span class='bold'>Responsable de Esterilización de Filtros</span></th><tr>" +
                                    "<tr>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Personal</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Fecha</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Hora Inicio</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Hora Final</span></th>" +
                                    "<th bgcolor='#cccccc'><span class='bold'>Horas Hombre</span></th>" +
                                    "<tr>");
                        consulta="select sppp.COD_PERSONAL,sppp.FECHA_INICIO,sppp.FECHA_FINAL,sppp.HORAS_HOMBRE,isnull((p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL))as nombrePersona "+
                                " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp"+
                                " left outer join  personal p on p.cod_personal=sppp.cod_personal "+
                                " left outer join  personal_temporal pt on pt.cod_personal=sppp.cod_personal "+
                                " where sppp.COD_PROGRAMA_PROD='"+codProgramaProd+"' and sppp.COD_LOTE_PRODUCCION='"+codLoteProduccion+"'"+
                                " and sppp.COD_COMPPROD='"+codCompProd+"' and sppp.COD_ACTIVIDAD_PROGRAMA='"+codActividadEsterilizacionFiltro+"'"+
                                " and sppp.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and sppp.COD_TIPO_PROGRAMA_PROD in("+codTipoprogramaProd+")" +
                                " order by sppp.FECHA_INICIO";
                       System.out.println("consulta personal esterilizacion utensilio"+consulta );
                       res=st.executeQuery(consulta);
                       while(res.next())
                       {
                           out.println("<tr>" +
                                        "<th><span class='normal'>"+res.getString("nombrePersona")+"</span></th>" +
                                        "<th><span class='normal'>"+(sdfDias.format(res.getTimestamp("FECHA_INICIO")))+"</span></th>"+
                                        "<th><span class='normal'>"+(sdfHoras.format(res.getTimestamp("FECHA_INICIO")))+"</span></th>"+
                                        "<th align='center'><span class='normal'>"+(sdfHoras.format(res.getTimestamp("FECHA_FINAL")))+"</span></th>" +
                                        "<th><span class='normal'>"+res.getString("HORAS_HOMBRE")+"</span></th>" +
                                        "</tr>");
                       }
                      out.println("</table>"+
                                  "<table width='80%' style='margin-top:0.6em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >");
                      cabeceraPersonal="";
                           innerCabeceraPersonal="";
                           detallePersonal="";
                           contDetalle=0;
                            consulta="select sllf.COD_PERSONAL,isnull((p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+'<br>'+p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+'<br>'+pt.NOMBRES_PERSONAL))as nombrePersonal"+
                                     " from SEGUIMIENTO_LIMPIEZA_LOTE_FILTROS sllf"+
                                             " left outer join personal p on sllf.COD_PERSONAL=p.COD_PERSONAL"+
                                             " left outer join personal_temporal pt on sllf.COD_PERSONAL=pt.COD_PERSONAL"+
                                     " where sllf.COD_SEGUIMIENTO_LIMPIEZA_LOTE='"+codSeguimiento+"'"+
                                     " group by sllf.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL"+
									 " ,pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL"+
                                     " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL";
                            System.out.println("consulta personal Registrado "+consulta);
                            res=st.executeQuery(consulta);
                            while(res.next())
                            {
                                innerCabeceraPersonal+="<th bgcolor='#cccccc' style='text-align:center;'><span class='bold'>"+res.getString("nombrePersonal")+"</span></th>";
                                cabeceraPersonal+=",ISNULL(sedl"+res.getRow()+".COD_FILTRO_PRODUCCION,0) as registrado"+res.getRow();
                                detallePersonal+=" left outer join SEGUIMIENTO_LIMPIEZA_LOTE_FILTROS sedl"+res.getRow()+" on"+
                                                 " sedl"+res.getRow()+".COD_FILTRO_PRODUCCION = fp.COD_FILTRO_PRODUCCION and"+
                                                 " sedl"+res.getRow()+".COD_SEGUIMIENTO_LIMPIEZA_LOTE = '"+codSeguimiento+"'" +
                                                 " and sedl"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                                contDetalle=res.getRow();
                            }
                        out.println("<tr>" +
                                    "<th colspan='"+contDetalle+"' bgcolor='#cccccc'><span class='bold'>FILTRO LIMPIADO</span></th>" +
                                    "<th rowspan='2' bgcolor='#cccccc'><span class='bold'>CODIGO<br> FILTRO</span></th>" +
                                    "<th rowspan='2' bgcolor='#cccccc'><span class='bold'>CANTIDAD<BR>FILTRO</span></th>" +
                                    "<th rowspan='2' bgcolor='#cccccc'><span class='bold'>MEDIO DE <BR>FILTRACION</span></th>" +
                                    "<th rowspan='2' bgcolor='#cccccc'><span class='bold'>PRESION DE <BR>APROBACION</span></th>" +
                                    "<th rowspan='2' bgcolor='#cccccc'><span class='bold'>UNIDAD MEDIDAD<BR>FILTRO</span></th>" +
                                    "</tr><tr>"+innerCabeceraPersonal+"</tr>");
                        consulta="select fp.COD_FILTRO_PRODUCCION,fp.CODIGO_FILTRO_PRODUCCION,fp.PRESION_DE_APROBACION,"+
                                 " mf.NOMBRE_MEDIO_FILTRACION,um.NOMBRE_UNIDAD_MEDIDA,um1.NOMBRE_UNIDAD_MEDIDA as unidadPresion,"+
                                 " fp.CANTIDAD_FILTRO"+cabeceraPersonal+
                                 " from FILTROS_PRODUCCION fp inner join FILTROS_PRODUCCION_PRODUCTOS fpp on "+
                                 " fp.COD_FILTRO_PRODUCCION=fpp.COD_FILTRO_PRODUCCION"+
                                 " inner join COMPONENTES_PROD cp on cp.COD_PROD=fpp.COD_PROD"+
                                 " inner join MEDIOS_FILTRACION mf on mf.COD_MEDIO_FILTRACION=fp.COD_MEDIO_FILTRACION"+
                                 " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fp.COD_UNIDAD_MEDIDA"+
                                 " inner join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA=fp.COD_UNIDAD_MEDIDA_PRESION"+
                                 detallePersonal+" where cp.COD_COMPPROD='"+codCompProd+"'"+
                                 " order by fp.CODIGO_FILTRO_PRODUCCION";
                        System.out.println("consulta filtros limpiados "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr>");
                            for(int i=1;i<=contDetalle;i++)out.println("<th><span>"+(res.getInt("registrado"+i)>0?"√":"&nbsp;")+"</span></th>");
                            out.println("<th><span class='normal'>"+res.getString("CODIGO_FILTRO_PRODUCCION")+"</span></th>" +
                                        "<th><span class='normal'>"+res.getString("CANTIDAD_FILTRO")+"</span></th>" +
                                        "<th><span class='normal'>"+res.getString("NOMBRE_MEDIO_FILTRACION")+"</span></th>" +
                                        "<th><span class='normal'>"+res.getString("PRESION_DE_APROBACION")+"</span></th>" +
                                        "<th><span class='normal'>"+res.getString("NOMBRE_UNIDAD_MEDIDA")+"</span></th>" +
                                        "</tr>");
                        }
                        out.println("</table><br><br><span class='bold'>NOMBRE DEL SUPERVISOR&nbsp;&nbsp;&nbsp;</span><span class='normal'>"+personalAprueba+"</span>" +
                                "<br><span class='bold'>Fecha:&nbsp;&nbsp;&nbsp;</span><span class='normal'>"+sdfDias.format(fechaCierre)+" </span>" +
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
