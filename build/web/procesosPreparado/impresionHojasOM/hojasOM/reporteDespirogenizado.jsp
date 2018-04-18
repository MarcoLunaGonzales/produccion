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
        width:100%;
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
                int codActividadDespiro=0;
                int codRecetaDespiro=0;
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
                                    "  isnull(dpff.CONDICIONES_GENERALES_DESPIROGENIZADO,'') as CONDICIONES_GENERALES_DESPIROGENIZADO"+
                                    " ,sdl.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE,sdl.FECHA_CIERRE"+
                                    " ,(per.AP_PATERNO_PERSONAL+' '+per.AP_MATERNO_PERSONAL+' '+per.NOMBRES_PERSONAL+' '+per.nombre2_personal) as nombrePersonal" +
                                    " ,isnull(loteAsociado.loteAsociado,'') as loteAsociado,isnull(loteAsociado.cantAsociado,0) as cantAsociado" +
                                    " ,sdl.OBSERVACION,isnull(afm.COD_ACTIVIDAD_FORMULA, 0) as codActividadDespirogenizado" +
                                    " ,isnull(cpr.COD_RECETA_DESPIROGENIZADO, 0) as COD_RECETA_DESPIROGENIZADO"+
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
                                    " inner join SEGUIMIENTO_DESPIROGENIZADO_LOTE sdl on sdl.COD_PROGRAMA_PROD =pp.COD_PROGRAMA_PROD and sdl.COD_LOTE = pp.COD_LOTE_PRODUCCION"+
                                    " inner join personal per on per.COD_PERSONAL=sdl.COD_PERSONAL_SUPERVISOR" +
                                    " left outer join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_AREA_EMPRESA ="+
                                    " 96 and afm.COD_ACTIVIDAD = 152 and afm.COD_FORMULA_MAESTRA ="+
                                    " pp.COD_FORMULA_MAESTRA and afm.COD_PRESENTACION = 0" +
                                    " left outer join COMPONENTES_PROD_RECETA cpr on cpr.COD_COMPROD =cp.COD_COMPPROD" +
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
                    String condicionesDespirogenizado="";
                    NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                    DecimalFormat format = (DecimalFormat)nf;
                    format.applyPattern("#,##0.0");
                    if(res.next())
                    {
                        codActividadDespiro=res.getInt("codActividadDespirogenizado");
                        codRecetaDespiro=res.getInt("COD_RECETA_DESPIROGENIZADO");
                        observacion=res.getString("OBSERVACION");
                        codSeguimiento=res.getInt("COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE");
                        fechaCierre=res.getTimestamp("FECHA_CIERRE");
                        personalAprueba=res.getString("nombrePersonal");
                        codCompProd=res.getInt("COD_COMPPROD");
                        loteAsociado=res.getString("loteAsociado");
                        cantAsociado=res.getInt("cantAsociado");
                        vidaUtil=res.getInt("vida_util");
                        condicionesDespirogenizado=res.getString("CONDICIONES_GENERALES_DESPIROGENIZADO").replace(b,'\n').replace("\n", "</br>").replace("</br></br>","<br>").replace("\"v\"","\"√\"");
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
                                "<th  align='center'><input type='text' size='3' value='4' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "<th  align='center'><span style='font-weight:normal'>de&nbsp;</span></th>" +
                                "<th  align='center' class='ultCol'><input type='text' size='3' value='10' style='text-align:center;border:none;background-color:#ffffff'></th>" +
                                "</tr>" +
                                "<tr>" +
                                "<th colspan='3'  align='center' rowspan='2'><span class='bold'><b>PROCESO DE DESPIROGENIZADO</b></span></th>" +
                                "<th  align='left'><span class='normal'>Lote</span></th>" +
                                "<th colspan='3' align='left' class='ultCol'><span class='normal'>"+(codLoteProduccion+(loteAsociado.equals("")?"":"<br>"+loteAsociado))+"</span></th>" +
                                "</tr><tr>" +
                                "<th  align='left'><span class='normal'>Expiración</span></th>" +
                                "<th  align='left' class='ultCol' colspan='3'>"+(fechaVencimiento.split("-").length>1?"<span class='normal'>"+fechaVencimiento+"</span>":"<input style='border:none' type='text' value='"+fechaVencimiento+"'/>")+"</th>" +
                                "</tr><tr>" +
                                "<th class='ultCol' colspan='9' style='padding:0 !important;font-size:6px !important' align='left'>&nbsp;</th>" +
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
                                "</tr><tr><th class='ultCol' colspan='9' style='padding:0 !important;font-size:6px !important'>&nbsp;</th></tr>" +
                                "<tr><th bgcolor='#cccccc' colspan='9' align='center' class='ultCol'><span class='bold' style='font-size:12px;'>DESPIROGENIZADO</span></th></tr>" +
                                "<tr><th colspan='9' align='left' class='ultCol ultFil'><span class='bold'>Condiciones Generales</span><br><br><span class='normal'>"+condicionesDespirogenizado+"</span>");
                                String cabeceraPersonal="";
                                String innerCabeceraPersonal="";
                                String detallePersonal="";
                                int contDetalle=0;
                                consulta="select s.COD_PERSONAL,isnull((p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+'<br>'+p.NOMBRES_PERSONAL),(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+'<br>'+pt.NOMBRES_PERSONAL))as nombrePersonal"+
                                         " from SEGUIMIENTO_ESPECIFICACIONES_DESPIROGENIZADO_LOTE s"+
                                         " left outer join personal p on p.COD_PERSONAL=s.COD_PERSONAL"+
                                         " left outer join personal_temporal pt on pt.COD_PERSONAL=s.COD_PERSONAL"+
                                         " where s.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE='"+codSeguimiento+"'"+
                                         " group by s.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL"+
                                         ",pt.AP_PATERNO_PERSONAL,pt.AP_MATERNO_PERSONAL,pt.NOMBRES_PERSONAL"+
                                         " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRES_PERSONAL";
                                res=st.executeQuery(consulta);
                                while(res.next())
                                {
                                    innerCabeceraPersonal+="<th colspan='2' bgcolor='#cccccc' align='center' ><span class='bold'>"+res.getString("nombrePersonal")+"</span></th>";
                                    cabeceraPersonal+=",ISNULL(sedl"+res.getRow()+".CONFORME,0) as conforme"+res.getRow()+"," +
                                                      "ISNULL(sedl"+res.getRow()+".OBSERVACION,'') as observacion"+res.getRow()+
                                                      ",ISNULL(sedl"+res.getRow()+".VALOR_EXACTO,0) AS valorExactoLote"+res.getRow();
                                    detallePersonal+=" left outer join SEGUIMIENTO_ESPECIFICACIONES_DESPIROGENIZADO_LOTE sedl"+res.getRow()+" on"+
                                                     " sedl"+res.getRow()+".COD_ESPECIFICACION_PROCESO = ep.COD_ESPECIFICACION_PROCESO and"+
                                                     " sedl"+res.getRow()+".COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE = '"+codSeguimiento+"'" +
                                                     " and sedl"+res.getRow()+".COD_PERSONAL='"+res.getInt("COD_PERSONAL")+"'";
                                    contDetalle=res.getRow();
                                }

                            out.println(" <table width='90%' style='margin-top:0.8em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th bgcolor='#cccccc' align='center' colspan='3'><span class='bold'>Especificaciones de Etapa de Despirogenizado</span></th>" +
                                "<th bgcolor='#cccccc' colspan='"+(contDetalle*2)+"' align='center'><span class='bold'>Condiciones de Etapa</span></th></tr>"+
                                "<tr><th bgcolor='#cccccc' rowspan='2'><span class='bold'>&nbsp</span></th>" +
                                "<th bgcolor='#cccccc' rowspan='2'><span class='bold'>Valor</span></th>"+
                                "<th bgcolor='#cccccc' rowspan='2'><span class='bold'>Unidad</span></th>"+
                                innerCabeceraPersonal+"</tr><tr>"
                                );
                            for(int i=0;i<contDetalle;i++)out.println("<th bgcolor='#cccccc'><span class='bold'>Conforme</span></th><th bgcolor='#cccccc'><span class='bold'>Observación</span></th>");
                            out.println("</tr>");
                        if(!loteAsociado.equals(""))tamanoLote+=cantAsociado;
                        consulta=" select ep.RESULTADO_ESPERADO_LOTE,ep.NOMBRE_ESPECIFICACIONES_PROCESO,isnull(um.ABREVIATURA, 'N.A') as NOMBRE_UNIDAD_MEDIDA,"+
                                 " ep.COD_ESPECIFICACION_PROCESO,case when ep.ESPECIFICACION_STANDAR_FORMA=1 then ep.VALOR_EXACTO else rd.VALOR_EXACTO end as valorExacto"+
                                 " , case when ep.ESPECIFICACION_STANDAR_FORMA=1 THEN"+
                                 " ep.VALOR_TEXTO else rd.VALOR_TEXTO end as valorTexto,ep.RESULTADO_NUMERICO" +cabeceraPersonal+
                                 " from ESPECIFICACIONES_PROCESOS ep left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA ="+
                                 " ep.COD_UNIDAD_MEDIDA left outer join RECETAS_DESPIROGENIZADO rd on"+
                                 " rd.COD_ESPECIFICACION_PROCESO = ep.COD_ESPECIFICACION_PROCESO and rd.COD_RECETA = '"+codRecetaDespiro+"'" +
                                  detallePersonal+
                                 " where ep.COD_FORMA = '"+codForma+"' and ep.COD_PROCESO_ORDEN_MANUFACTURA=1"+
                                 " order by ep.ORDEN";
                        System.out.println("consulta detalle materiales "+consulta);
                        res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr><th><span class='normal'>"+res.getString("NOMBRE_ESPECIFICACIONES_PROCESO")+"</span></th>" +
                                        "<th><span class='normal'>"+(res.getInt("RESULTADO_NUMERICO")>0?(res.getInt("valorExacto")>0?String.valueOf(res.getInt("valorExacto")):""):res.getString("valorTexto"))+"</span></th>"+
                                        "<th align='center'><span class='normal'>"+(res.getString("NOMBRE_UNIDAD_MEDIDA"))+"</span></th>");
                            for(int i=1;i<=contDetalle;i++)out.println("<th align='center'><span class='normal'>"+(res.getInt("RESULTADO_ESPERADO_LOTE")==1?res.getDouble("valorExactoLote"+i):(res.getInt("conforme"+i)>0?"√":"&nbsp;"))+"</span></th><th align='center'><span class='normal'>"+res.getString("observacion"+i)+"&nbsp;</span></th>");
                            out.println("</tr>");
                        }
                        out.println("</table><table width='90%' style='margin-top:0.8em' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th bgcolor='#cccccc' align='center' ><span class='bold'>N°</span></th>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>N° de <br>Amp. por<br>Bandejas</span></th>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>N° de <br>Bandejas</span></th>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>N° de <br>Amp. <br>Totales</span></th>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>N° de <br>Amp. <br>Rotas</span></th>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>Obrero</span></th>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>Fecha</span></th>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>Hora<br>Inicio</span></th>" +
                                "<th bgcolor='#cccccc'  align='center'><span class='bold'>Hora<br>Final</span></th>" +
                                "</tr>");

                        consulta="select sadl.CANTIDAD_AMPOLLAS_BANDEJA,sadl.CANTIDAD_AMPOLLAS_ROTAS,sadl.CANTIDAD_AMPOLLAS_ROTAS,"+
                                 "isnull(sadl.CANTIDAD_BANDEJAS, - 1) as CANTIDAD_BANDEJAS,sppp.FECHA_INICIO,sppp.FECHA_FINAL,"+
                                 " isnull((p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal),(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL+' '+pt.nombre2_personal))as nombrePersonal"+
                                 " from SEGUIMIENTO_AMPOLLAS_DESPIROGENIZADO_LOTE sadl"+
                                 " inner join SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp on sppp.COD_PERSONAL = sadl.COD_PERSONAL and"+
                                 " sadl.COD_REGISTRO_ORDEN_MANUFACTURA = sppp.COD_REGISTRO_ORDEN_MANUFACTURA"+
                                 " left outer join personal p on p.COD_PERSONAL=sadl.COD_PERSONAL"+
                                 " left outer join personal_temporal pt on pt.COD_PERSONAL=sadl.COD_PERSONAL"+
                                 " where (sppp.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and sppp.COD_PROGRAMA_PROD = '"+codProgramaProd+"'" +
                                 " and sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadDespiro+"'" +
                                 " and sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoprogramaProd+"' and sadl.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE is null) or"+
                                 " (sadl.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE = '"+codSeguimiento+"' and sppp.COD_LOTE_PRODUCCION is NULL) or"+
                                 " (sppp.COD_LOTE_PRODUCCION = '"+codLoteProduccion+"' and sppp.COD_PROGRAMA_PROD = '"+codProgramaProd+"'" +
                                 " and sppp.COD_FORMULA_MAESTRA = '"+codFormulaMaestra+"' and sppp.COD_ACTIVIDAD_PROGRAMA = '"+codActividadDespiro+"'" +
                                 " and sppp.COD_TIPO_PROGRAMA_PROD = '"+codTipoprogramaProd+"' and sadl.COD_SEGUIMIENTO_DESPIROGENIZADO_LOTE = "+codSeguimiento+")"+
                                 " order by sadl.COD_REGISTRO_ORDEN_MANUFACTURA";
                        System.out.println("consulta seguimiento "+consulta);
                        res=st.executeQuery(consulta);
                        int cantAmpollasDespiro=0;
                        int cantAmpollasRotas=0;
                        while(res.next())
                        {
                            cantAmpollasRotas+=res.getInt("CANTIDAD_AMPOLLAS_ROTAS");
                            cantAmpollasDespiro+=(res.getInt("CANTIDAD_AMPOLLAS_BANDEJA")*res.getInt("CANTIDAD_BANDEJAS"));
                            out.println("<tr>" +
                                        "<th align='center' ><span class='normal'>"+res.getRow()+"</span></th>" +
                                        "<th align='center'><span class='normal'>"+res.getInt("CANTIDAD_AMPOLLAS_BANDEJA")+"</span></th>" +
                                        "<th align='center'><span class='normal'>"+res.getInt("CANTIDAD_BANDEJAS")+"</span></th>" +
                                        "<th align='center'><span class='normal'>"+res.getInt("CANTIDAD_AMPOLLAS_BANDEJA")*res.getInt("CANTIDAD_BANDEJAS")+"</span></th>" +
                                        "<th align='center'><span class='normal'>"+res.getInt("CANTIDAD_AMPOLLAS_ROTAS")+"</span></th>" +
                                        "<th align='center'><span class='normal'>"+res.getString("nombrePersonal")+"</span></th>" +
                                        "<th align='center'><span class='normal'>"+sdfDias.format(res.getTimestamp("FECHA_INICIO"))+"</span></th>" +
                                        "<th align='center'><span class='normal'>"+sdfHoras.format(res.getTimestamp("FECHA_INICIO"))+"</span></th>" +
                                        "<th align='center'><span class='normal'>"+sdfHoras.format(res.getTimestamp("FECHA_FINAL"))+"</span></th>" +
                                        "</tr>");
                        }
                        consulta="select  isnull(sum(sall.CANTIDAD_AMPOLLAS_BANDEJAS*sall.CANTIDAD_BANDEJAS),0) as cantidadAmpollas," +
                                " isnull(SUM (sall.CANTIDAD_AMPOLLAS_ROTAS),0) as CANTIDAD_AMPOLLAS_ROTAS " +
                                " from SEGUIMIENTO_LAVADO_LOTE sll inner join SEGUIMIENTO_AMPOLLAS_LAVADO_LOTE sall on sll.COD_SEGUIMIENTO_LAVADO_LOTE=sall.COD_SEGUIMIENTO_LAVADO_LOTE " +
                                "where sll.COD_PROGRAMA_PROD='"+codProgramaProd+"' and sll.COD_LOTE='"+codLoteProduccion+"'";
                        int cantidadAmpollasLavadas=0;
                        res=st.executeQuery(consulta);
                        if(res.next())cantidadAmpollasLavadas=res.getInt("cantidadAmpollas")-res.getInt("CANTIDAD_AMPOLLAS_ROTAS");
                        out.println("</table></th></tr></table></div><div class='pagina'>" +
                                "<table width='80%' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th style='border-bottom:none'><table width='80%' align='center' class='outputText0'  cellpadding='0' cellspacing='0' >" +
                                "<tr><th colspan='3' bgcolor='#cccccc'  align='center'><span class='bold'>Rendimiento del Proceso de Despirogenizado</span></th></tr>" +
                                "<tr><th style='border:none' align='left'><span class='normal'>Cantidad de ampollas teoricas lavadas</span></th>" +
                                "<th style='border:none'><span class='normal'>&nbsp;</span></th>" +
                                "<th style='border-bottom:none' align='left'><span class='normal'>"+cantidadAmpollasLavadas+"</span></th>" +
                                "</tr>" +
                                "<tr><th style='border:none' align='left'><span class='normal'>Cantidad de ampollas despirogenizadas</span></th>" +
                                "<th style='border:none'><span class='normal'>&nbsp;</span></th>" +
                                "<th style='border-bottom:none' align='left'><span class='normal'>"+cantAmpollasDespiro+"</span></th>" +
                                "</tr>" +
                                "<tr><th style='border:none' align='left'><span class='normal'>Cantidad de ampollas rotas</span></th>" +
                                "<th style='border:none'><span class='normal'>&nbsp;</span></th>" +
                                "<th style='border-bottom:none' align='left'><span class='normal'>"+cantAmpollasRotas+"</span></th>" +
                                "</tr>" +
                                "<tr><th style='border-right:none' align='left'><span class='normal'>Rendimiento Final</span></th>" +
                                "<th style='border:none;border-bottom:1px solid black'><span class='normal'>&nbsp;</span></th>" +
                                "<th style='' align='left'><span class='normal'>"+Math.rint(((Double.valueOf(cantAmpollasDespiro)-Double.valueOf(cantAmpollasRotas))/Double.valueOf(cantidadAmpollasLavadas))*10000d)/100d+"</span></th>" +
                                "</tr>" +
                                "</table></th></tr><tr><th align='left' class='ultCol ultFil'>" +
                                "<br><br><span class='bold'>NOMBRE DEL SUPERVISOR</span><span class='normal'><b>:</b>&nbsp;&nbsp;&nbsp;&nbsp"+personalAprueba+"</span>" +
                                "<br><span class='bold'>Fecha:&nbsp;&nbsp;&nbsp;</span><span class='normal'>"+sdfDias.format(fechaCierre)+" </span>" +
                                "<br><br><span class='bold'>OBSERVACIONES:&nbsp;&nbsp;&nbsp;</span><br><span class='normal'>"+observacion+"</span>" +
                                "<br><br><br><br><br><br>" +
                                "</th></tr>");
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
