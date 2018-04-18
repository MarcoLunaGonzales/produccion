package procesosPreparado.seguimientoProcesoPorLote.seguimientoProcesosEspecificaciones;

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
    <body >
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
                 String loteAsociado="";
                 int cantAsociado=0;
                 NumberFormat nf1 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formato= (DecimalFormat)nf1;
                formato.applyPattern("####.#####");
                NumberFormat nf2 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formato2= (DecimalFormat)nf2;
                formato2.applyPattern("###0.000000");
                 NumberFormat n1 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formato1= (DecimalFormat)n1;
                formato1.applyPattern("###0.0");
                NumberFormat n22 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formato22= (DecimalFormat)n22;
                formato22.applyPattern("###0.00");
                NumberFormat n3 = NumberFormat.getNumberInstance(Locale.ENGLISH);
                DecimalFormat formato3= (DecimalFormat)n22;
                formato3.applyPattern("###0.000");
                String fechaVencimiento="";
                double sumaCantidadRecubrimiento=0;
                String nombreEnvase="";
                int cantidadEnvasePrimario=0;
                int vidaUtil=0;
                  try
                  {
                    Connection con=null;
                    con=Util.openConnection(con);
                    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    String consulta="select pp.cod_formula_maestra, isnull(cpr.COD_RECETA_LAVADO, 0) as cod_receta_lavado,f.cod_forma,pp.COD_FORMULA_MAESTRA,cp.COD_COMPPROD,f.abreviatura_forma,p.nombre_prod,cp.NOMBRE_GENERICO,f.nombre_forma,cp.REG_SANITARIO,"+
                                    " ep.nombre_envaseprim,cp.VIDA_UTIL,pp.CANT_LOTE_PRODUCCION,ppp.FECHA_FINAL,cp.cod_area_empresa" +
                                    " ,cp.PESO_ENVASE_PRIMARIO,tpp.ABREVIATURA as abtp,(cast (cp.CANTIDAD_VOLUMEN as varchar) + ' ' + um.ABREVIATURA) as VOLUMEN_ENVASE_PRIMARIO,fm.CANTIDAD_LOTE,ppm.CANTIDAD,cpm.NOMBRE_COLORPRESPRIMARIA" +
                                    " ,cp.CANTIDAD_VOLUMEN,um.ABREVIATURA,cp.TOLERANCIA_VOLUMEN_FABRICAR,tpp.COD_TIPO_PROGRAMA_PROD,tpp.COD_TIPO_PROGRAMA_PROD" +
                                    " ,cpr.OBSERVACION_DENSIDAD" +
                                    ",ISNULL((select top 1 spp.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION spp"+
                                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = spp.COD_ACTIVIDAD_PROGRAMA and"+
                                    "  spp.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA where spp.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION and afm.COD_ACTIVIDAD = 186"+
                                    "  order by spp.FECHA_FINAL DESC ), (select top 1 spp1.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION spp1"+
                                    "  inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = spp1.COD_ACTIVIDAD_PROGRAMA and"+
                                    "  spp1.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA where spp1.COD_LOTE_PRODUCCION = pp.COD_LOTE_PRODUCCION and afm.COD_ACTIVIDAD in (71,48) "+
                                    "  order by spp1.FECHA_FINAL DESC )) as fecha" +
                                    " ,isnull(loteAsociado.loteAsociado,'') as loteAsociado,isnull(loteAsociado.cantAsociado,0) as cantAsociado"+
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
                                    " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cp.COD_UNIDAD_MEDIDA_VOLUMEN" +
                                    " outer APPLY(select top 1 lpc.COD_LOTE_PRODUCCION_ASOCIADO as loteAsociado,pp1.CANT_LOTE_PRODUCCION as cantAsociado"+
                                    " from LOTES_PRODUCCION_CONJUNTA lpc inner join PROGRAMA_PRODUCCION pp1 on"+
                                    " lpc.COD_PROGRAMA_PROD=pp1.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION_ASOCIADO=pp1.COD_LOTE_PRODUCCION"+
                                    " where lpc.COD_PROGRAMA_PROD=pp.COD_PROGRAMA_PROD and lpc.COD_LOTE_PRODUCCION=pp.COD_LOTE_PRODUCCION"+
                                    " and pp1.COD_COMPPROD=pp.COD_COMPPROD) loteAsociado"+
                                    " where pp.COD_LOTE_PRODUCCION='"+codLote+"' and pp.cod_programa_prod='"+codProgramaProd+"' order by tpp.COD_TIPO_PROGRAMA_PROD,ppp.FECHA_FINAL desc";
                    System.out.println("consulta cargar datos del lote "+consulta);
                    ResultSet res=st.executeQuery(consulta);

                    SimpleDateFormat sdf=new SimpleDateFormat("MM-yyyy");
                    String nombreProd="";
                    String nombreEnvasePrimario="";
                    String nombreGenerico="";
                    String registroSanitario="";
                    
                    String nombreForma="";
                    String tamLote="";
                    String abreviaturaForma="";
                    String abreviaturaTP="ABREVIATURA";
                    String codComprodMix="";
                    Double[] prod1=new Double[4];
                    Double[] prod2=new Double[3];
                    int codForma=0;
                    String nombreColor="";
                    String volumenEnvasePrimario="";
                    int cantidadVolumenEnvasePrimario=0;
                    String pesoEnvasePrimario="";
                    double tamanoLote=0d;
                    String codReceta="";
                    String codFormulaMaestra="";
                    double cantidadVolumenEnvase=0d;
                    double toleranciaVolumen=0d;
                    String codTipoprogramaProd="";
                    String observacionDensidad="";
                    if(res.next())
                    {
                        loteAsociado=res.getString("loteAsociado");
                        cantAsociado=res.getInt("cantAsociado");
                        vidaUtil=res.getInt("vida_util");
                        observacionDensidad=res.getString("OBSERVACION_DENSIDAD");
                        codTipoprogramaProd=res.getString("COD_TIPO_PROGRAMA_PROD");
                        toleranciaVolumen=res.getDouble("TOLERANCIA_VOLUMEN_FABRICAR");
                        codFormulaMaestra=res.getString("cod_formula_maestra");
                        codReceta=res.getString("cod_receta_lavado");
                        codComprodMix=res.getString("COD_COMPPROD");
                        prod1[0]=res.getDouble("COD_COMPPROD");
                        prod1[1]=(res.getDouble("CANT_LOTE_PRODUCCION")/res.getDouble("CANTIDAD_LOTE"));
                        tamanoLote=res.getDouble("CANT_LOTE_PRODUCCION");
                        prod1[2]=res.getDouble("COD_FORMULA_MAESTRA");
                        prod1[3]=res.getDouble("CANTIDAD_LOTE");
                        cantidadVolumenEnvase=res.getDouble("CANTIDAD_VOLUMEN");
                        volumenEnvasePrimario=formato.format(cantidadVolumenEnvase)+" "+res.getString("ABREVIATURA");  //res.getString("VOLUMEN_ENVASE_PRIMARIO").toLowerCase();;
                        System.out.println("vol "+volumenEnvasePrimario);
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
                            " where i.LOTE_MATERIAL_PROVEEDOR = '"+codLote+"' ";
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
                            pesoEnvasePrimario=res.getString("PESO_ENVASE_PRIMARIO");
                            cantidadVolumenEnvasePrimario=res.getInt("CANTIDAD");
                            nombreColor=res.getString("NOMBRE_COLORPRESPRIMARIA");
                            codForma=res.getInt("cod_forma");
                            nombreForma=res.getString("nombre_forma");
                            nombreProd=res.getString("nombre_prod");
                            nombreEnvasePrimario=res.getString("nombre_envaseprim").toLowerCase();
                            nombreEnvase=res.getString("nombre_envaseprim").toUpperCase();
                            
                            nombreEnvasePrimario+=((codForma==2||codForma==14||codForma==33||codForma==16|| codForma==10||codForma==26||codForma==27||codForma==29)?" "+nombreColor+" por "+volumenEnvasePrimario:
                                                  ((codForma==6||codForma==1||codForma==32||(codForma>=35&&codForma<=41))?" por "+cantidadVolumenEnvasePrimario+" "+nombreForma.toLowerCase():
                                                 ((codForma==7||codForma==25)?" por "+volumenEnvasePrimario:
                                                 ((codForma==12||codForma==20||codForma==31||codForma==11||codForma==34||codForma==30||codForma==13)?" por "+pesoEnvasePrimario:
                                                  ((codForma==36)?" por "+cantidadVolumenEnvasePrimario+"comprimidos":"") ))));

                            nombreGenerico=res.getString("NOMBRE_GENERICO");
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
                            pesoEnvasePrimario=res.getString("PESO_ENVASE_PRIMARIO");
                            cantidadVolumenEnvasePrimario=res.getInt("CANTIDAD");
                            nombreColor=res.getString("NOMBRE_COLORPRESPRIMARIA");
                            codForma=res.getInt("cod_forma");
                            nombreForma=res.getString("nombre_forma");
                            nombreProd=res.getString("nombre_prod");
                            nombreEnvasePrimario+=((codForma==2||codForma==14||codForma==33||codForma==16|| codForma==10||codForma==26||codForma==27||codForma==29)?" "+nombreColor+" por "+volumenEnvasePrimario:
                                                  ((codForma==6||codForma==1||codForma==32||(codForma>=35&&codForma<=41))?" por "+cantidadVolumenEnvasePrimario+" "+nombreForma.toLowerCase():
                                                 ((codForma==7||codForma==25)?" por "+volumenEnvasePrimario:
                                                 ((codForma==12||codForma==20||codForma==31||codForma==11||codForma==34||codForma==30||codForma==13)?" por "+pesoEnvasePrimario:
                                                  ((codForma==36)?" por "+cantidadVolumenEnvasePrimario+"comprimidos":"") ))))+"("+res.getString("abtp")+")";
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
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><input type='text' size='3' value='0' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center'><span class='outputText2'><b>&nbsp;de&nbsp;</b></span></th>" +
                                "<th style='border-bottom : solid #000000 1px' align='center'><input type='text' size='3' value='0' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "</tr>" +
                                "<tr>" +
                                "<th colspan='3' style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='center' rowspan='2'><span class='outputText2'><b>FORMULA CUALI-CUANTITATIVA</b></span></th>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Lote</span></th>" +
                                "<th style='border-bottom: solid #000000 1px;' align='left' colspan='3'><span class='normal'>"+(codLote+(loteAsociado.equals("")?"":"<br>"+loteAsociado))+"</span></th>" +
                                "</tr><tr>" +
                                "<th style='border-bottom: solid #000000 1px;border-right:solid #000000 1px' align='left'><span class='normal'>Expiración</span></th>" +
                                "<th style='border-bottom : solid #000000 1px;' align='left' colspan='3'>"+(fechaVencimiento.split("-").length>1?"<span class='normal'>"+fechaVencimiento+"</span>":"<input style='border:none' type='text' value='"+fechaVencimiento+"'/>")+"</th>" +
                                "</tr><tr>" +
                                "<th  colspan='9' style='border-bottom: solid #000000 1px;font-size:4px' align='left'>&nbsp;</th>" +
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
                                "<th colspan='2'  style='border-right:solid #000000 1px' align='left'><span class='normal'>"+tamLote+(loteAsociado.equals("")?"":"<br>"+cantAsociado)+"</span></th>" +
                                "<th align='left'><span class='normal'>"+abreviaturaForma+"</span></th>" +
                                "</tr>"
                                );//<tr><th style='border-top:solid #000000 1px;border-bottom:solid #000000 1px;font-size:4px;' colspan='9'>&nbsp;</th></tr>
                        consulta="select r.VALOR_EXACTO from RECETAS_DESPIROGENIZADO r inner join COMPONENTES_PROD_RECETA cpr on"+
                                 " r.COD_RECETA=cpr.COD_RECETA_DOSIFICADO "+
                                 " where r.COD_ESPECIFICACION_PROCESO=28"+
                                 " and cpr.COD_COMPROD='"+codCompProd+"'";
                        
                        System.out.println("consulta  cargar volumen envasado "+consulta);
                        double cantidadfabricar=0d;
                        double volumenEnvasado=0d;
                        double cantidadUnitariaProduccion=0d;
                        res=st.executeQuery(consulta);
                        if(res.next())
                        {
                            volumenEnvasado=res.getDouble("VALOR_EXACTO");
                        }
                        if(!loteAsociado.equals(""))tamanoLote+=cantAsociado;
                        String color="white";
                        System.out.println("ve "+volumenEnvasado+" tl "+toleranciaVolumen);
                        cantidadfabricar=(volumenEnvasado*tamanoLote)/1000;
                        cantidadfabricar+=(((toleranciaVolumen/100))*cantidadfabricar);
                        String unidadCabecera="Litros";
                        color=(cantidadVolumenEnvase>5&&toleranciaVolumen==0)?"red":color;
                        cantidadfabricar=Math.rint(cantidadfabricar*10)/10;
                        cantidadUnitariaProduccion=cantidadVolumenEnvase/1000;
                        if(codForma==1||(codForma>=35&&codForma<=41))
                        {
                            unidadCabecera="Comp";
                            cantidadfabricar=tamanoLote+ (tamanoLote*toleranciaVolumen);
                            cantidadUnitariaProduccion=1;
                        }
                       // System.out.println(volumenfabricar);
                        
                            out.println("<tr><th bgcolor='#cccccc' colspan='9' style='font-size:12px;border-bottom: solid #000000 1px;border-top: solid #000000 1px;' align='center'><span class='outputText2' style='font-size:12px;'>FORMULA CUALI-CUANTITATIVA</span></th></tr><tr>" +
                                "<th  colspan='9' style='border-bottom: solid #000000 1px;' align='center'>" +
                                "<center><table class='outputText2' style='width:90%;margin-top:3px;margin-bottom:3px;border: solid #000000 1px;' cellpadding='0' cellspacing='0' >" +
                                    "<tr>" +
                                    "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' rowspan='2' align='center'>MATERIAS PRIMAS</td>" +
                                    "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' rowspan='2' align='center'>TIPO</td>"+
                                    "<td colspan='2' style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='center'>"+((codForma==1||(codForma>=35&&codForma<=41))?"PESO UNITARIO":"UNITARIA<br>(Por "+(codForma==2?"ampolla":"frasco")+")")+"</td>"+
                                    "<td colspan='2' style='font-weight:bold;border-bottom:solid #000000 1px;' align='center'>"+((codForma==1||(codForma>=35&&codForma<=41))?"PESO":"")+" LOTE INDUSTRIAL</td>"+
                                    "</tr><tr>" +
                                    "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px;padding-right:3px;' align='center'>"+formato.format(cantidadUnitariaProduccion)+"</td>" +
                                    "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px;padding-right:3px;' align='center'>"+unidadCabecera+"</td>"+
                                    "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px;padding-right:3px;' align='right' bgcolor='"+color+"'>"+formato.format(cantidadfabricar)+"</td>" +
                                    "<td style='font-weight:bold;border-bottom:solid #000000 1px;padding-left:3px;padding-right:3px;' align='center'>"+unidadCabecera+"</td>"+
                                    "</tr><tr bgcolor='#cccccc'><td colspan='6' style='height:4px;padding:0px;font-size:1px;border-bottom:solid #000000 1px'>&nbsp;</td></tr>");
                            consulta="select m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.ABREVIATURA,sum(fmdf.CANTIDAD) as CANTIDAD,um.COD_UNIDAD_MEDIDA"+
                                     " from FORMULA_MAESTRA_DETALLE_MP fmd " +
                                     "inner join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmdf"+
                                     " on fmd.COD_FORMULA_MAESTRA=fmdf.COD_FORMULA_MAESTRA and "+
                                     " fmd.COD_MATERIAL=fmdf.COD_MATERIAL"+
                                     " inner join materiales m on m.COD_MATERIAL=fmd.COD_MATERIAL"+
                                     " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA"+
                                     " where fmd.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and isnull(fmdf.COD_TIPO_MATERIAL_PRODUCCION,0) =0" +
                                     " group by m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.ABREVIATURA,um.COD_UNIDAD_MEDIDA" +
                                     " order by m.NOMBRE_MATERIAL";
                            System.out.println("consulta buscar materiales fm "+consulta);
                            
                            res=st.executeQuery(consulta);
                            double sumaTotal=0;
                            double cantidadLote=0;
                            double cantidadUnitaria=0d;
                            String abreviatura="";
                            while(res.next())
                            {
                                cantidadLote=res.getDouble("CANTIDAD")*prod1[1];
                                cantidadLote=(res.getInt("COD_UNIDAD_MEDIDA")==3?1000:1)*cantidadLote;
                                cantidadLote=((tamanoLote/prod1[3])*cantidadLote);
                                abreviatura=(res.getInt("COD_UNIDAD_MEDIDA")==3?"g":res.getString("ABREVIATURA"));
                                if(codForma==1||(codForma>=35&&codForma<=41))
                                {
                                    cantidadUnitaria=(cantidadLote/cantidadfabricar);
                                    if(!(res.getInt("COD_MATERIAL")==5014||res.getInt("COD_MATERIAL")==4090||(res.getInt("COD_MATERIAL")>=116&&res.getInt("COD_MATERIAL")<=118)))
                                    {
                                        sumaTotal+=(Math.rint(cantidadLote*10)/10);
                                    }
                                }
                                else
                                {
                                    cantidadUnitaria=(cantidadLote/cantidadfabricar)*(cantidadVolumenEnvase/1000);
                                    sumaTotal+=(Math.rint(cantidadLote*10)/10);
                                }

                                out.println("<tr>" +
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px' align='left'>"+res.getString("NOMBRE_MATERIAL")+"</td>" +
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px' align='left'>&nbsp;</td>"+
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-right:3px' align='right'>"+formato2.format(cantidadUnitaria)+"</td>" +
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px' align='center'>"+abreviatura+"</td>"+
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-right:3px' align='right'>"+formato1.format(cantidadLote)+"</td>" +
                                    "<td style='font-weight:normal;border-bottom:solid #000000 1px;' align='center'>"+abreviatura+"</td>"+
                                    "</tr>");
                            }
                            if(codForma==1||(codForma>=35&&codForma<=41))
                            {
                                consulta="select m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.ABREVIATURA,sum(fmdf.CANTIDAD) as CANTIDAD,um.COD_UNIDAD_MEDIDA"+
                                     " from FORMULA_MAESTRA_DETALLE_MP fmd " +
                                     "inner join FORMULA_MAESTRA_DETALLE_MP_FRACCIONES fmdf"+
                                     " on fmd.COD_FORMULA_MAESTRA=fmdf.COD_FORMULA_MAESTRA and "+
                                     " fmd.COD_MATERIAL=fmdf.COD_MATERIAL"+
                                     " inner join materiales m on m.COD_MATERIAL=fmd.COD_MATERIAL"+
                                     " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA"+
                                     " where fmd.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"' and fmdf.COD_TIPO_MATERIAL_PRODUCCION =1" +
                                     " group by m.COD_MATERIAL,m.NOMBRE_MATERIAL,um.ABREVIATURA,um.COD_UNIDAD_MEDIDA" +
                                     " order by m.NOMBRE_MATERIAL";
                                    System.out.println("consulta cargar Materiales recubrimiento comprimidos "+consulta);
                                    res=st.executeQuery(consulta);
                                    if(res.next())
                                    {
                                        out.println("<tr>" +
                                            "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px' align='left'><span style='font-weight:bold'>RECUBRIMIENTO</span></td>" +
                                            "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px' align='left'>&nbsp;</td>"+
                                            "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-right:3px' align='right'>&nbsp;</td>" +
                                            "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px' align='left'>&nbsp;</td>"+
                                            "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-right:3px' align='right'>&nbsp;</td>" +
                                            "<td style='font-weight:normal;border-bottom:solid #000000 1px;' align='center'>&nbsp;</td>"+
                                            "</tr>");
                                        cantidadLote=res.getDouble("CANTIDAD")*prod1[1];
                                        cantidadLote=(res.getInt("COD_UNIDAD_MEDIDA")==3?1000:1)*cantidadLote;
                                        abreviatura=(res.getInt("COD_UNIDAD_MEDIDA")==3?"g":res.getString("ABREVIATURA"));
                                        cantidadUnitaria=(cantidadLote/cantidadfabricar);
                                        if(!(res.getInt("COD_MATERIAL")==5014||res.getInt("COD_MATERIAL")==4090||(res.getInt("COD_MATERIAL")>=116&&res.getInt("COD_MATERIAL")<=118)))
                                        {
                                            sumaCantidadRecubrimiento+=(Math.rint(cantidadLote*10)/10);
                                        }
                                        out.println("<tr>" +
                                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px' align='left'>"+res.getString("NOMBRE_MATERIAL")+"</td>" +
                                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px' align='left'>&nbsp;</td>"+
                                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-right:3px' align='right'>"+formato2.format(cantidadUnitaria)+"</td>" +
                                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px' align='center'>"+abreviatura+"</td>"+
                                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-right:3px' align='right'>"+formato1.format(cantidadLote)+"</td>" +
                                                    "<td style='font-weight:normal;border-bottom:solid #000000 1px;' align='center'>"+abreviatura+"</td>"+
                                                    "</tr>");
                                    }
                                    while(res.next())
                                    {
                                        cantidadLote=res.getDouble("CANTIDAD")*prod1[1];
                                        cantidadLote=(res.getInt("COD_UNIDAD_MEDIDA")==3?1000:1)*cantidadLote;
                                        abreviatura=(res.getInt("COD_UNIDAD_MEDIDA")==3?"g":res.getString("ABREVIATURA"));
                                        cantidadUnitaria=(cantidadLote/cantidadfabricar);
                                        if(!(res.getInt("COD_MATERIAL")==5014||res.getInt("COD_MATERIAL")==4090||(res.getInt("COD_MATERIAL")>=116&&res.getInt("COD_MATERIAL")<=118)))
                                        {
                                            sumaCantidadRecubrimiento+=(Math.rint(cantidadLote*10)/10);
                                        }
                                        out.println("<tr>" +
                                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px' align='left'>"+res.getString("NOMBRE_MATERIAL")+"</td>" +
                                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px' align='left'>&nbsp;</td>"+
                                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-right:3px' align='right'>"+formato2.format(cantidadUnitaria)+"</td>" +
                                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px' align='center'>"+abreviatura+"</td>"+
                                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-right:3px' align='right'>"+formato1.format(cantidadLote)+"</td>" +
                                                    "<td style='font-weight:normal;border-bottom:solid #000000 1px;' align='center'>"+abreviatura+"</td>"+
                                                    "</tr>");
                                    }
                            }
                           out.println("<tr><td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='left'>&nbsp;</td>" +
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='left'>&nbsp;</td>"+
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='left'>&nbsp;</td>" +
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='left'>&nbsp;</td>"+
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='right'>&nbsp;</td>" +
                                    "<td style='font-weight:normal;border-bottom:solid #000000 1px;' align='left'>&nbsp;</td></tr>" +
                                    "<tr><td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px;' align='left'>"+((codForma==1||(codForma>=35&&codForma<=41))?"PESO TEORICO SIN RECUBRIMIENTO":"PESO TOTAL")+"</td>" +
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='left'>&nbsp;</td>"+
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-right:3px' align='right'>"+((codForma==1||(codForma>=35&&codForma<=41))?formato2.format((sumaTotal/cantidadfabricar)):"&nbsp;")+"</td>" +
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='center'>"+((codForma==1||(codForma>=35&&codForma<=41))?"g":"&nbsp;")+"</td>"+
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-right:3px;' align='right'>"+formato1.format(sumaTotal)+"</td>" +
                                    "<td style='font-weight:normal;border-bottom:solid #000000 1px;' align='center'>g</td></tr>" +
                                    "<tr><td style='border-right: solid #000000 1px;font-weight:normal;padding-left:3px;' align='left'>"+(((codForma==1||(codForma>=35&&codForma<=41))&&sumaCantidadRecubrimiento>0)?"PESO TEORICO CON RECUBRIMIENTO":"&nbsp;")+"</td><td style='border-right: solid #000000 1px' align='right'>&nbsp;</td>" +
                                    "<td style='border-right: solid #000000 1px;font-weight:normal;padding-right:3px' align='right'>"+(((codForma==1||(codForma>=35&&codForma<=41))&&sumaCantidadRecubrimiento>0)?formato2.format((sumaCantidadRecubrimiento/cantidadfabricar)+(sumaTotal/cantidadfabricar)):"&nbsp;")+"</td>" +
                                    "<td style='border-right: solid #000000 1px;font-weight:normal' align='center'>"+(((codForma==1||(codForma>=35&&codForma<=41))&&sumaCantidadRecubrimiento>0)?"g":"&nbsp;")+"</td>" +
                                    "<td style='border-right: solid #000000 1px;font-weight:normal' align='right'>"+(((codForma==1||(codForma>=35&&codForma<=41))&&sumaCantidadRecubrimiento>0)?formato1.format(sumaCantidadRecubrimiento+sumaTotal):"&nbsp;")+"</td>" +
                                    "<td style='font-weight:normal;'>"+(((codForma==1||(codForma>=35&&codForma<=41))&&sumaCantidadRecubrimiento>0)?"g":"&nbsp;")+"</td></tr>" +
                                    "</table></center></th></tr>" +
                                    "<tr bgcolor='#cccccc'><td colspan='9' class='outputText2' align='center' style='border-bottom:1px solid black;padding:2px;font-weight:bold;font-size=12px;'>MATERIAL PRIMARIO</td></tr>" +
                                    "<tr><td colspan='9' style='border-bottom:1px solid black;'><center>"+
                                    "<table class='outputText2' style='width:90%;margin-bottom:3px;margin-top:3px;border-top: solid #000000 1px;border-left: solid #000000 1px;border-right: solid #000000 1px;' cellpadding='0' cellspacing='0' >");
                           if(codForma==1||(codForma>=35&&codForma<=41))
                           {
                               out.println("<tr>" +
                                "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='center' rowspan='2' >MATERIAL PRIMARIO</td>" +
                                "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='center' rowspan='2'>MATERIAL POR UNIDAD</td>"+
                                "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='center' colspan='2'>PESO UNITARIO</td>"+
                                "<td style='font-weight:bold;border-bottom:solid #000000 1px;' align='center' colspan='2'>PESO LOTE INDUSTRIAL</td>"+
                                "</tr><tr>"+
                                "<td style='font-weight:bold;border-bottom:solid #000000 1px;' align='center' >1</td>"+
                                "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='center' >"+nombreEnvase+"</td>"+
                                "<td style='font-weight:bold;border-bottom:solid #000000 1px;width:7em' align='center' >"+formato1.format(cantidadfabricar/cantidadVolumenEnvasePrimario)+"</td>"+
                                "<td style='font-weight:bold;border-bottom:solid #000000 1px;' align='center' >"+nombreEnvase+"</td>"+
                                "</tr>"
                                );
                           }
                           else
                           {
                               out.println("<tr>" +
                                "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='center'>CODIGO</td>" +
                                "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='center'>MATERIAL PRIMARIO</td>"+
                                "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='center'>UNITARIA<br>"+(codForma==2?"(Por Ampolla)":"(Por Frasco)")+"</td>"+
                                "<td style='font-weight:bold;border-bottom:solid #000000 1px;' align='center'>LOTE INDUSTRIAL</td>"+
                                "</tr><tr>");
                           }
                           consulta="select m.NOMBRE_MATERIAL,um.ABREVIATURA, fmd.CANTIDAD,m.CODIGO_ANTIGUO"+
                                    ((codForma==1||(codForma>=35&&codForma<=41))?" ,tpp.NOMBRE_TIPO_PROGRAMA_PROD,um.ABREVIATURA ":"")+
                                    " from FORMULA_MAESTRA_DETALLE_EP fmd"+
                                    " inner join materiales m on fmd.COD_MATERIAL = m.COD_MATERIAL"+
                                    " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA ="+
                                    " fmd.COD_UNIDAD_MEDIDA  "+
                                    " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA="+
                                    " fmd.COD_FORMULA_MAESTRA"+
                                    " inner join PRESENTACIONES_PRIMARIAS pp on pp.COD_COMPPROD"+
                                    " =fm.COD_COMPPROD"+
                                    " and fmd.COD_PRESENTACION_PRIMARIA=pp.COD_PRESENTACION_PRIMARIA"+
                                    " and pp.COD_TIPO_PROGRAMA_PROD in ("+codTipoprogramaProd+")"+
                                    ((codForma==1||(codForma>=35&&codForma<=41))?" inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD =pp.COD_TIPO_PROGRAMA_PROD ":"")+
                                    " where fmd.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"'"+
                                    " order by m.NOMBRE_MATERIAL" ;

                           System.out.println("consulta material ep "+consulta);
                           res=st.executeQuery(consulta);
                           while(res.next())
                           {
                               out.println("<tr>" +
                                   ((codForma==1||(codForma>=35&&codForma<=41))?"":"<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:6px' align='left'>"+res.getString("CODIGO_ANTIGUO")+"&nbsp;</td>") +
                                    "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:3px' align='left'>"+res.getString("NOMBRE_MATERIAL")+"</td>" +
                                    ((codForma==1||(codForma>=35&&codForma<=41))?"<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='center'>"+res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+"&nbsp;</td>" +
                                    "<td style='border-bottom:solid #000000 1px;width:6em;' align='center'>"+formato3.format(res.getDouble("CANTIDAD")/(tamanoLote/cantidadVolumenEnvasePrimario))+"</td>" +
                                    "<td style='border-bottom:solid #000000 1px; border-right: solid #000000 1px;width:6em;' align='center'>"+res.getString("ABREVIATURA")+"</td>":"") +
                                    ((codForma==1||(codForma>=35&&codForma<=41))?"":"<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:6px' align='left'>1 "+abreviaturaForma+"</td>")+
                                    "<td style='font-weight:normal;border-bottom:solid #000000 1px;' align='center'>"+((tamanoLote/prod1[3])*res.getInt("CANTIDAD"))+" " +((codForma==1||(codForma>=35&&codForma<=41))?"":abreviaturaForma)+"</td>"+
                                    ((codForma==1||(codForma>=35&&codForma<=41))?"<td style='border-bottom:solid #000000 1px;width:6em;' align='left'>"+res.getString("ABREVIATURA")+"</td>":"")+
                                    "</tr>");
                           }
                           out.println("</table></center></td></tr>" +
                                    "<tr bgcolor='#cccccc'><td colspan='9' class='outputText2' align='center' style='border-bottom:1px solid black;padding:2px;font-weight:bold;font-size=12px;'>REACTIVOS PARA ANALISIS</td></tr>" +
                                    "<tr>"+
                                    "<tr><td colspan='9'  aling='center'><center>"+
                                    "<table class='outputText2' style='width:70%;margin-bottom:3px;margin-top:3px;border-top: solid #000000 1px;border-left: solid #000000 1px;border-right: solid #000000 1px;' cellpadding='0' cellspacing='0' >" +
                                    "<tr>" +
                                    "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='center'>NOMBRE</td>" +
                                    "<td style='font-weight:bold;border-right: solid #000000 1px;border-bottom:solid #000000 1px;' align='center'>CANTIDAD</td>"+
                                    "<td style='font-weight:bold;border-bottom:solid #000000 1px;' align='center'>UNIDAD<br>MEDIDAD</td>"+
                                    "</tr><tr>");
                                    
                           consulta="select m.NOMBRE_MATERIAL,fmd.CANTIDAD,um.ABREVIATURA"+
                                    " from FORMULA_MAESTRA_DETALLE_MR fmd inner join materiales m on"+
                                    " fmd.COD_MATERIAL=m.COD_MATERIAL inner join UNIDADES_MEDIDA um"+
                                    " on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA"+
                                    " where fmd.COD_FORMULA_MAESTRA='"+codFormulaMaestra+"'"+
                                    " order by m.NOMBRE_MATERIAL";
                           System.out.println("consulta mat reac "+consulta);
                           res=st.executeQuery(consulta);
                           while(res.next())
                           {
                                out.println("<tr>" +
                                       "<td style='font-weight:normal;border-right: solid #000000 1px;border-bottom:solid #000000 1px;padding-left:6px' align='left'>"+res.getString("NOMBRE_MATERIAL")+"&nbsp;</td>" +
                                    "<td style='font-weight:normal;border-bottom:solid #000000 1px;border-right: solid #000000 1px;' align='center'>"+formato22.format(((tamanoLote/prod1[3])*res.getDouble("CANTIDAD")))+" "+res.getString("ABREVIATURA")+"</td>" +
                                    "<td style='font-weight:normal;border-bottom:solid #000000 1px;' align='center'>"+res.getString("ABREVIATURA")+"</td>" +
                                    "</tr>");
                           }
                            out.println("</table></center></td></tr>" +
                                "<tr ><td colspan='9' class='outputText2' align='left' style='padding:2px;font-weight:bold;font-size=12px;'>" +
                                "Observaciones:"+observacionDensidad+"</td></tr>" +
                                "<tr ><td colspan='8' class='outputText2' align='left' style='padding:2px;font-weight:bold;font-size=12px;'>&nbsp;</td>" +
                                "<td align='center' style='border-bottom:1px solid black;border-top:1px solid black;border-left:1px solid black;padding:5px;font-weight:bold;font-size=14px;'>VERSION 1</td>"+
                                "</tr>" +
                                "<tr><td colspan='9' style='width:35%' align='center'>" +
                                "<table style='width:100%'><tr><td style='width:50%'>"+
                                "<table class='outputText2' style='width:70%;margin-bottom:8px;margin-top:8px;padding:3px;border-top: solid #000000 1px;border-left: solid #000000 1px;border-right: solid #000000 1px;' cellpadding='0' cellspacing='0' >" +
                                    "<tr>" +
                                    "<td colspan='2' style='font-weight:bold;border-bottom:solid #000000 1px;padding:3px' align='center'>JEFE DE PRODUCCION</td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td  style='width:30%;border-right:solid black 1px;border-bottom:solid black 1px;padding:6px' align='left'>NOMBRE</td>" +
                                    "<td  style='border-bottom:solid #000000 1px;padding:6px' align='center'>&nbsp;</td>" +
                                    "</tr>"+
                                    "<tr>" +
                                    "<td  style='width:30%;border-right:solid black 1px;border-bottom:solid black 1px;padding:6px' align='left'>FIRMA</td>" +
                                    "<td  style='border-bottom:solid #000000 1px;padding:6px' align='center'>&nbsp;</td>" +
                                    "</tr>"+
                                    "<tr>" +
                                    "<td  style='width:30%;border-right:solid black 1px;border-bottom:solid black 1px;padding:6px' align='left'>FECHA</td>" +
                                    "<td  style='border-bottom:solid #000000 1px;padding:6px' align='center'>&nbsp;</td>" +
                                    "</tr>"+
                                    "</table></td><td>"+
                                    "<table class='outputText2' style='width:70%;margin-bottom:8px;margin-top:8px;padding:3px;border-top: solid #000000 1px;border-left: solid #000000 1px;border-right: solid #000000 1px;' cellpadding='0' cellspacing='0' >" +
                                    "<tr>" +
                                    "<td colspan='2' style='font-weight:bold;border-bottom:solid #000000 1px;padding:3px' align='center'>DIRECTOR TÉCNICO</td>" +
                                    "</tr>" +
                                    "<tr>" +
                                    "<td  style='width:30%;border-right:solid black 1px;border-bottom:solid black 1px;padding:6px' align='left'>NOMBRE</td>" +
                                    "<td  style='border-bottom:solid #000000 1px;padding:6px' align='center'>&nbsp;</td>" +
                                    "</tr>"+
                                    "<tr>" +
                                    "<td  style='width:30%;border-right:solid black 1px;border-bottom:solid black 1px;padding:6px' align='left'>FIRMA</td>" +
                                    "<td  style='border-bottom:solid #000000 1px;padding:6px' align='center'>&nbsp;</td>" +
                                    "</tr>"+
                                    "<tr>" +
                                    "<td  style='width:30%;border-right:solid black 1px;border-bottom:solid black 1px;padding:6px' align='left'>FECHA</td>" +
                                    "<td  style='border-bottom:solid #000000 1px;padding:6px' align='center'>&nbsp;</td>" +
                                    "</tr>"+
                                    "</table></td></tr></table>"+
                                "</td>" +
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
