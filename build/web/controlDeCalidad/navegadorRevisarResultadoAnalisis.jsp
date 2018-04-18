<%@page contentType="text/html"%>
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<%@ page language="java" %>
<%@ page import="com.cofar.util.*" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.Connection"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.text.SimpleDateFormat"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import="java.util.Locale" %>
<%@page import="java.text.DecimalFormatSymbols" %>
<%@ page import = "java.text.NumberFormat"%>
<f:view>
<%!private boolean verificarResultadoAprobar(String codTipoResultadoAnalisis,String codTipoResultadoDescriptivo,double resultadoNumerico,double limiteSuperior,double limiteInferior,double valorExacto)
    {
        boolean resultado=true;
        if(codTipoResultadoAnalisis.equals("1"))
        {
            if(codTipoResultadoDescriptivo.equals("2"))
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("2"))
        {
            if((resultadoNumerico>limiteSuperior)||(resultadoNumerico<limiteInferior))
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("3"))
        {
            if((resultadoNumerico!=valorExacto))
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("4"))
        {
            if(resultadoNumerico<=valorExacto)
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("5"))
        {
            if(resultadoNumerico>=valorExacto)
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("6"))
        {
            if(resultadoNumerico<valorExacto)
            {
                return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("7"))
        {
            if(resultadoNumerico>valorExacto)
            {
               return false;
            }
        }
        if(codTipoResultadoAnalisis.equals("8"))
        {
            if((resultadoNumerico>=(-valorExacto))||(resultadoNumerico<valorExacto))
            {
                return false;
            }
            
        }
        if(codTipoResultadoAnalisis.equals("9"))
        {
            if(resultadoNumerico>valorExacto)
            {
                return false;
            }

        }
        if(codTipoResultadoAnalisis.equals("10"))
        {
            if(resultadoNumerico<valorExacto)
            {
                return false;
            }

        }
        
        return resultado;
    }

%>
    <html>
        <head>
            <meta http-equiv="Expires" content="0">
            <meta http-equiv="Last-Modified" content="0">
            <meta http-equiv="Cache-Control" content="no-cache, mustrevalidate">
            <meta http-equiv="Pragma" content="no-cache">
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
            <style  type="text/css">
                .a{
                background-color : #F2F5A9;
                }
                .b{
                background-color : #ffffff;
                }
                .columns{
                border:0px solid red;
                }
                .simpleTogglePanel{
                text-align:center;
                }
                .ventasdetalle{
                font-size: 13px;
                font-family: Verdana;
                }
                .preciosaprobados{
                background-color:#33CCFF;
                }
                .enviado{
                background-color:#FFFFCC;
                }
                .pasados{
                background-color:#ADD797;
                }
                .pendiente{
                background-color : #ADD797;
                }
                .leyendaColorAnulado{
                background-color: #FF6666;
                }          
                .a1{
                  background-color:#000000;
                }
                .a2{
                  background-color:#FFB6C1;
                }
                
            </style>
           <script>
                   A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error: "+message);
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }
            </script>
        </head>
        
        <body   > 
            <a4j:form id="form1" >
                <div align="center">
                    
                    <h:outputText styleClass="outputTextTitulo"  value="REVISION DE RESULTADOS DE ANALISIS" />
                    <br></br>
                    <%
                    ManagedResultadoAnalisis managed=(ManagedResultadoAnalisis)Util.getSession("ManagedResultadoAnalisis");

                     Connection con=null;
                    String consulta="select max(pp.COD_PROGRAMA_PROD) as codProg from PROGRAMA_PRODUCCION pp where pp.COD_LOTE_PRODUCCION='"+managed.getResultadoAnalisisBean().getCodLote()+"' and pp.COD_PROGRAMA_PROD in ("+
                                         " select p.COD_PROGRAMA_PROD from PROGRAMA_PRODUCCION_PERIODO p where p.COD_TIPO_PRODUCCION=1 and p.COD_ESTADO_PROGRAMA<>4)";
                    System.out.println("consulta buscar lote "+consulta);
                      String nombreAnalista="";
                        String nombreJefeControldeCalidad="";
                    try
                        {
                            NumberFormat numeroformato = NumberFormat.getNumberInstance(Locale.ENGLISH);
                            DecimalFormat formato = (DecimalFormat) numeroformato;
                            formato.applyPattern("#,##0.00");
                            con=Util.openConnection(con);
                            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                            ResultSet res=st.executeQuery(consulta);
                            String codProgramaProd="";
                            if(res.next())
                            {
                                codProgramaProd=res.getString("codProg");
                            }
                    consulta="select cp.COD_VERSION,pr.nombre_prod,ra.FECHA_EMISION,ae.COD_AREA_EMPRESA,ae.NOMBRE_AREA_EMPRESA,"+
                             " isnull(ra.NRO_ANALISIS_MICROBIOLOGICO, '') as NRO_ANALISIS_MICROBIOLOGICO,"+
                             " isnull(ra.NRO_ANALISIS,'') as NRO_ANALISIS,cp.VIDA_UTIL,cp.nombre_prod_semiterminado,cp.COD_COMPPROD,"+
                             " ff.nombre_forma,(p.NOMBRE_PILA + ' ' + p.AP_PATERNO_PERSONAL + ' ' +p.AP_MATERNO_PERSONAL) as nombreAnalista,"+
                             " ISNULL((select top 1 spp.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp"+
                             " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = spp.COD_ACTIVIDAD_PROGRAMA and"+
                             " spp.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA where spp.COD_LOTE_PRODUCCION = ra.COD_LOTE and afm.COD_ACTIVIDAD = 186"+
                             " order by spp.FECHA_FINAL DESC ), (select top 1 spp1.FECHA_INICIO from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp1"+
                             " inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_ACTIVIDAD_FORMULA = spp1.COD_ACTIVIDAD_PROGRAMA and"+
                             " spp1.COD_FORMULA_MAESTRA = afm.COD_FORMULA_MAESTRA where spp1.COD_LOTE_PRODUCCION = ra.COD_LOTE and afm.COD_ACTIVIDAD = 76"+
                             " order by spp1.FECHA_FINAL DESC )) as fecha,pp1.CANT_LOTE_PRODUCCION,tpp.ABREVIATURA,fccc.URL_FIRMA,era.COD_ESTADO_RESULTADO_ANALISIS,"+
                             " era.NOMBRE_ESTADO_RESULTADO_ANALISIS,ra.TOMO,ra.PAGINA,ff.cod_forma,(cast(cp.CANTIDAD_VOLUMEN as varchar)+' '+um.ABREVIATURA) as VOLUMEN_ENVASE_PRIMARIO,cp.CONCENTRACION_ENVASE_PRIMARIO,"+
                             " cp.PESO_ENVASE_PRIMARIO,ff.nombre_forma,cp.nombre_prod_semiterminado,cpprim.NOMBRE_COLORPRESPRIMARIA,isnull(("+
                             " select top 1 cast (ep.nombre_envaseprim as varchar) + '%' + cast(ppcp.CANTIDAD as varchar) from PRESENTACIONES_PRIMARIAS_VERSION ppcp "+
                             " inner join ENVASES_PRIMARIOS ep on ep.cod_envaseprim =ppcp.COD_ENVASEPRIM where ppcp.COD_COMPPROD = cp.COD_COMPPROD and ppcp.COD_VERSION=cp.COD_VERSION and "+
                             " ppcp.COD_TIPO_PROGRAMA_PROD = pp1.COD_TIPO_PROGRAMA_PROD), '') as presentacionPrimaria" +
                             " ,cp.NOMBRE_COMERCIAL"+
                             " from PROGRAMA_PRODUCCION pp1 inner join COMPONENTES_PROD_VERSION cp on cp.COD_VERSION = pp1.COD_COMPPROD_VERSION"+
                             " and cp.COD_COMPPROD=pp1.COD_COMPPROD inner join FORMAS_FARMACEUTICAS ff on "+
                             " cp.COD_FORMA=ff.cod_forma inner join AREAS_EMPRESA ae on ae.COD_AREA_EMPRESA=cp.COD_AREA_EMPRESA"+
                             " left outer join COLORES_PRESPRIMARIA cpprim on cpprim.COD_COLORPRESPRIMARIA= cp.COD_COLORPRESPRIMARIA" +
                             " left outer join productos pr on pr.cod_prod=cp.COD_PROD"+
                             " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=pp1.COD_TIPO_PROGRAMA_PROD"+
                             " left outer join RESULTADO_ANALISIS ra on ra.cod_lote=pp1.COD_LOTE_PRODUCCION"+
                             " and ra.COD_COMPROD=pp1.COD_COMPPROD "+
                             " left outer join PERSONAL p on p.COD_PERSONAL = ra.COD_PERSONAL_ANALISTA"+
                             " left outer join FIRMAS_CERTIFICADO_CC fccc on fccc.COD_PERSONAL =ra.COD_PERSONAL_ANALISTA"+
                             " left outer join ESTADOS_RESULTADO_ANALISIS era on era.COD_ESTADO_RESULTADO_ANALISIS = ra.COD_ESTADO_RESULTADO_ANALISIS"+
                             " left outer join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cp.COD_UNIDAD_MEDIDA_VOLUMEN"+
                             " where pp1.COD_LOTE_PRODUCCION = '"+managed.getResultadoAnalisisBean().getCodLote()+"' and pp1.COD_PROGRAMA_PROD = '"+codProgramaProd+"'" +
                             " and pr.cod_prod='"+managed.getResultadoAnalisisBean().getComponenteProd().getProducto().getCodProducto()+"'"+
                             " and cp.cod_Forma='"+managed.getResultadoAnalisisBean().getComponenteProd().getForma().getCodForma()+"'"+
                             " ORDER BY ra.COD_COMPROD desc";
                            System.out.println("consulta cabecera "+consulta);
                            res=st.executeQuery(consulta);
                            String fechaElaboracion="";
                            String fechaVencimiento="";
                            SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
                            String codComprod="";
                            int codForma=0;
                            String nombreProductoSemiterminado="";
                            String nombreFormaFar="";
                            String presentacion="";
                            String tamLote="";
                            String nombreTipo="";
                            String nroAnalisis="";
                            String nroMicro="";
                            SimpleDateFormat sdf2=new SimpleDateFormat("MM/yyyy");
                            int codVersion=0;
                            if(res.next())
                            {
                                codVersion=res.getInt("COD_VERSION");
                                nroMicro=res.getString("NRO_ANALISIS_MICROBIOLOGICO");
                                nroAnalisis=res.getString("NRO_ANALISIS");
                                nombreAnalista=res.getString("nombreAnalista");
                                codComprod=res.getString("COD_COMPPROD");
                                codForma=res.getInt("cod_forma");
                                nombreFormaFar=res.getString("nombre_forma");
                                
                                String presenPrimaria=(res.getString("presentacionPrimaria").split("%").length>0?res.getString("presentacionPrimaria").split("%")[0]:"");
                                //System.out.println(presenPrimaria);
                                String cantidadPresenPrimaria=(res.getString("presentacionPrimaria").split("%").length>1?res.getString("presentacionPrimaria").split("%")[1]:"");
                                
                                String volumenPresenPrimaria=res.getString("VOLUMEN_ENVASE_PRIMARIO");
                                String conPresenPrimaria=res.getString("CONCENTRACION_ENVASE_PRIMARIO");
                                String pesoPresenPrimaria=res.getString("PESO_ENVASE_PRIMARIO");
                                String colorPresenPrimaria=res.getString("NOMBRE_COLORPRESPRIMARIA");
                                String nombreFormaPresentacion="";
                                if((codForma==6||codForma==1||codForma==32||codForma==37||codForma==38||codForma==39||codForma==40||codForma==41||codForma==42))
                                {
                                    String[] array=nombreFormaFar.split(" ");
                                    for(String a:array)
                                    {
                                        nombreFormaPresentacion+=a+"s ";
                                    }

                                }
                                presentacion=presenPrimaria+" "+((codForma==2||codForma==14||codForma==33||codForma==16|| codForma==10||codForma==26||codForma==27||codForma==29)?colorPresenPrimaria+" por "+volumenPresenPrimaria:
                                         ((codForma==6||codForma==1||codForma==32||codForma==37||codForma==38||codForma==39||codForma==40||codForma==41||codForma==42)?" por "+cantidadPresenPrimaria+" "+nombreFormaPresentacion:
                                         ((codForma==7||codForma==25)?" por "+volumenPresenPrimaria:
                                         ((codForma==12||codForma==20||codForma==31||codForma==11||codForma==34||codForma==30||codForma==13)?"por "+pesoPresenPrimaria:
                                          ((codForma==36)?" por "+cantidadPresenPrimaria+" comprimido":"") ))));
                                System.out.println(presentacion);
                                presentacion=presentacion.toLowerCase();
                                String a=String.valueOf(presentacion.charAt(0));
                                presentacion=presentacion.replaceFirst(a,a.toUpperCase());
                                tamLote=res.getInt("CANT_LOTE_PRODUCCION")+" "+((codForma==1||codForma==6||codForma==32||codForma==37||codForma==38||codForma==39||codForma==40||codForma==41||codForma==42)?nombreFormaPresentacion:res.getString("presentacionPrimaria").split("%")[0]+"s");
                                tamLote=tamLote.toLowerCase();
                                String codAreaEmpresa=res.getString("COD_AREA_EMPRESA");
                                nombreProductoSemiterminado=res.getString("NOMBRE_COMERCIAL").trim();
                                /*if(nombreProductoSemiterminado.length()>5)
                                {
                                    String nombreref=nombreProductoSemiterminado.substring(nombreProductoSemiterminado.length()-4, nombreProductoSemiterminado.length()).toLowerCase();
                                    if(nombreref.equals(" ref"))
                                    {
                                        nombreProductoSemiterminado=nombreProductoSemiterminado.substring(0,nombreProductoSemiterminado.length()-4);
                                    }
                                }*/
                                StringBuilder consulta1=new StringBuilder(" exec PAA_LISTAR_FECHA_VENCIMIENTO_LOTE")
                                                        .append("'").append(managed.getResultadoAnalisisBean().getCodLote()).append("',")
                                                        .append(codProgramaProd).append(",")
                                                        .append(codComprod).append(",")
                                                        .append(codForma).append(",")
                                                        .append("?,")//mensaje
                                                        .append("?,")//fecha vencimiento
                                                        .append("?");//fecha pesaje
                                System.out.println("consulta obtener vida util producto "+consulta1.toString());
                                CallableStatement callFechaVencimiento=con.prepareCall(consulta1.toString());
                                callFechaVencimiento.registerOutParameter(1,java.sql.Types.VARCHAR);
                                callFechaVencimiento.registerOutParameter(2,java.sql.Types.TIMESTAMP);
                                callFechaVencimiento.registerOutParameter(3,java.sql.Types.TIMESTAMP);
                                callFechaVencimiento.execute();
                                SimpleDateFormat sdfMMYY=new SimpleDateFormat("MM/yyyy");
                                fechaVencimiento=callFechaVencimiento.getString(1).length()>0?"No pudo calcular la fecha de vencimiento":sdfMMYY.format(callFechaVencimiento.getTimestamp(2));
                                fechaElaboracion=callFechaVencimiento.getTimestamp(3)!=null?sdf.format(callFechaVencimiento.getTimestamp(3)):"No cuenta con fecha de pesaje";
                                if((codComprod.equals("7")||codComprod.equals("8"))&&fechaElaboracion==null)
                                {
                                    consulta="select MIN(spp.FECHA_INICIO) as fechaInicio"+
                                             " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp inner join ACTIVIDADES_FORMULA_MAESTRA afm"+
                                             " on spp.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA and spp.COD_FORMULA_MAESTRA=afm.COD_FORMULA_MAESTRA"+
                                             " and afm.COD_AREA_EMPRESA=96"+
                                             " where afm.COD_ACTIVIDAD in (71,48) and spp.COD_LOTE_PRODUCCION='"+managed.getResultadoAnalisisBean().getCodLote()+"'";
                                    System.out.println("consulta buscar fecha elaboracion "+consulta);
                                    Statement stdet=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                    ResultSet resDet=stdet.executeQuery(consulta);
                                    if(resDet.next())
                                    {
                                       if(resDet.getDate("fechaInicio")!=null)
                                       {
                                           fechaElaboracion=sdf.format(resDet.getDate("fechaInicio"));
                                       }
                                       else
                                       {
                                           consulta="select MIN(spp.FECHA_INICIO) as fechaInicio"+
                                                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL spp inner join ACTIVIDADES_FORMULA_MAESTRA afm"+
                                                    " on spp.COD_ACTIVIDAD_PROGRAMA=afm.COD_ACTIVIDAD_FORMULA and spp.COD_FORMULA_MAESTRA=afm.COD_FORMULA_MAESTRA"+
                                                    " and afm.COD_AREA_EMPRESA=96"+
                                                    " where afm.COD_ACTIVIDAD in (29,40,88) and spp.COD_LOTE_PRODUCCION='"+managed.getResultadoAnalisisBean().getCodLote()+"'";
                                           System.out.println("consulta buscar fecha envasado "+consulta);
                                           resDet=stdet.executeQuery(consulta);
                                           if(resDet.next())
                                           {
                                               fechaElaboracion=sdf.format(resDet.getDate("fechaInicio"));
                                           }
                                       }
                                    }
                                
                                    resDet.close();
                                    stdet.close();
                                }
                                nombreTipo=res.getString("ABREVIATURA");
                        }
                           
                         if(res.next())
                        {
                            String  presenPrimaria=(res.getString("presentacionPrimaria").split("%").length>0?res.getString("presentacionPrimaria").split("%")[0]:"");
                            String cantidadPresenPrimaria=(res.getString("presentacionPrimaria").split("%").length>1?res.getString("presentacionPrimaria").split("%")[1]:"");
                            String volumenPresenPrimaria=res.getString("VOLUMEN_ENVASE_PRIMARIO");
                            String conPresenPrimaria=res.getString("CONCENTRACION_ENVASE_PRIMARIO");
                            String pesoPresenPrimaria=res.getString("PESO_ENVASE_PRIMARIO");
                            String colorPresenPrimaria=res.getString("NOMBRE_COLORPRESPRIMARIA");
                             nombreFormaFar=res.getString("nombre_forma");
                            codForma=res.getInt("cod_forma");
                            String nombreFormaPresentacion="";
                                if((codForma==6||codForma==1||codForma==32||codForma==37||codForma==38||codForma==39||codForma==40||codForma==41||codForma==42))
                                {
                                    String[] array=nombreFormaFar.split(" ");
                                    for(String ac:array)
                                    {
                                        nombreFormaPresentacion+=ac+"s ";
                                    }

                                }
                            String pres2=presenPrimaria+" "+((codForma==2||codForma==14||codForma==33||codForma==16|| codForma==10||codForma==26||codForma==27||codForma==29)?colorPresenPrimaria+" por "+volumenPresenPrimaria:
                                         ((codForma==6||codForma==1||codForma==32||codForma==37||codForma==38||codForma==39||codForma==40||codForma==41||codForma==42)?"por "+cantidadPresenPrimaria+" "+nombreFormaPresentacion:
                                         ((codForma==7||codForma==25)?"por "+volumenPresenPrimaria:
                                         ((codForma==12||codForma==20||codForma==31||codForma==11||codForma==34||codForma==30||codForma==13)?"por "+pesoPresenPrimaria:
                                          ((codForma==36)?"por "+cantidadPresenPrimaria+"comprimidos":"") ))));
                            presentacion+="("+nombreTipo+") <br/> "+pres2.toLowerCase()+" ("+res.getString("ABREVIATURA")+")";
                            String ta=res.getInt("CANT_LOTE_PRODUCCION")+" "+((codForma==1||codForma==6||codForma==32||codForma==37||codForma==38||codForma==39||codForma==40||codForma==41||codForma==42)?nombreFormaPresentacion:res.getString("presentacionPrimaria").split("%")[0]+"s");
                            ta=ta.toLowerCase();
                            /*char[] ad=ta.toCharArray();
                            if(ad[ad.length-1]!='s')
                              ta+="s";*/
                            tamLote+=" ("+nombreTipo+") <br/> "+ta+" ("+res.getString("ABREVIATURA")+")";
                        }
                        consulta="select YEAR(id.FECHA_VEN) as year,MONTH(id.FECHA_VEN)as month from INGRESOS_DETALLEACOND id where id.COD_LOTE_PRODUCCION='"+managed.getResultadoAnalisisBean().getCodLote()+"'" +
                                " and id.COD_COMPPROD='"+codComprod+"'" +
                                " group by YEAR(id.FECHA_VEN),MONTH(id.FECHA_VEN)";
                                 
                        System.out.println("consulta carga fecha vencimiento acond "+consulta);
                        res=st.executeQuery(consulta);
                        String tablaFechasAcond="<table cellpading='0' cellspacing='0'>" +
                                                "<tr><td class='headerClassACliente border' style='border:1px solid #cccccc;padding:8px'><span>Fechas Venc. Acond.<span></td></tr>";
                        while(res.next())
                        {
                            String fechaVencAcond=(res.getInt("month")>9?"":"0")+res.getString("month")+"/"+res.getString("year");
                            tablaFechasAcond+="<tr><td bgcolor='#"+(fechaVencimiento.equals(fechaVencAcond)?"90EE90":"FFA07A")+
                                              "'><center><span class='outputText2'>"+fechaVencAcond+"</span></center></td></tr>";
                        }
                        tablaFechasAcond+="</table>";
						consulta="select year(i.FECHA_VENC) as year,MONTH(i.FECHA_VENC) as month from INGRESOS_DETALLEVENTAS i where i.COD_LOTE_PRODUCCION='"+managed.getResultadoAnalisisBean().getCodLote()+"'" +
                                " and cast(i.COD_INGRESOVENTAS as varchar)+'-'+cast(i.COD_AREA_EMPRESA as varchar) in"+
                                " (select cast(iv.COD_INGRESOVENTAS as varchar)+'-'+cast(iv.COD_AREA_EMPRESA as varchar) "+
                                " from INGRESOS_VENTAS iv where iv.COD_ESTADO_INGRESOVENTAS<>2  and iv.FECHA_INGRESOVENTAS>'2012/01/01 00:00:00' and iv.COD_ALMACEN_VENTA<>32"+
                                " ) and i.COD_PRESENTACION in (select cpp.COD_PRESENTACION from COMPONENTES_PRESPROD cpp where cpp.COD_COMPPROD='"+codComprod+"')" +
                                " group by year(i.FECHA_VENC),MONTH(i.FECHA_VENC)";
                        System.out.println("consulta fecha venc lote apt "+consulta);
                        String tablaFechasApt="<table cellpading='0' cellspacing='0'>" +
                                                "<tr><td class='headerClassACliente border' style='border:1px solid #cccccc;padding:8px'><span>Fechas Venc. APT.<span></td></tr>";
                        res=st.executeQuery(consulta);
                         while(res.next())
                        {
                            String fechaVencApt=(res.getInt("month")>9?"":"0")+res.getString("month")+"/"+res.getString("year");
                            tablaFechasApt+="<tr><td bgcolor='#"+(fechaVencimiento.equals(fechaVencApt)?"90EE90":"FFA07A")+
                                              "'><center><span class='outputText2'>"+fechaVencApt+"</span></center></td></tr>";
                        }
                        tablaFechasApt+="</table>";
                        
                        
                    %>
                    <div class="" style="width:80%;border:solid 1px #cccccc">
                        <div class=" headerClassACliente">
                                Datos del Lote
                        </div>
                        <div class="" style="background-color:#eeeeee">
                            <table>
                                <tr style="text-align:left;">
                                    <td><span class="outputText2" style="font-weight:bold;">PRODUCTO</span></td><td><span class="outputText2" style="font-weight:bold;">:</span></td>
                                    <td><span class="outputText2" ><%=nombreProductoSemiterminado%></span>
                                    <td><span class="outputText2" style="font-weight:bold;">LOTE</span></td><td><span class="outputText2" style="font-weight:bold;">:</span></td>
                                    <td><span class="outputText2" ><%=managed.getResultadoAnalisisBean().getCodLote()%></span>
                                </tr>
                                <tr style="text-align:left;">
                                    <td><span class="outputText2" style="font-weight:bold;">FORMA FARMACEUTICA</span></td><td><span class="outputText2" style="font-weight:bold;">:</span></td>
                                    <td><span class="outputText2" ><%=nombreFormaFar%></span>
                                    <td><span class="outputText2" style="font-weight:bold;">PRESENTACION</span></td><td><span class="outputText2" style="font-weight:bold;">:</span></td>
                                    <td><span class="outputText2" ><%=presentacion%></span>
                                </tr>
                                 <tr style="text-align:left;">
                                    <td><span class="outputText2" style="font-weight:bold;">FECHA ELABORACION</span></td><td><span class="outputText2" style="font-weight:bold;">:</span></td>
                                    <td><span class="outputText2" ><%=fechaElaboracion%></span>
                                    <td><span class="outputText2" style="font-weight:bold;">FECHA VENCIMIENTO</span></td><td><span class="outputText2" style="font-weight:bold;">:</span></td>
                                    <td><span class="outputText2" ><%=fechaVencimiento%></span>
                                </tr>
                                   <tr style="text-align:left;">
                                    <td rowspan="2"><span class="outputText2" style="font-weight:bold;" >TAMAÑO DEL LOTE</span></td><td rowspan="2"><span class="outputText2" style="font-weight:bold;">:</span></td>
                                    <td rowspan="2"><span class="outputText2" ><%=tamLote%></span>
                                    <td><span class="outputText2" style="font-weight:bold;">N° ANÁLISIS FISICO QUIMICO</span></td><td><span class="outputText2" style="font-weight:bold;">:</span></td>
                                    <td><span class="outputText2" ><%=(nroAnalisis)%></span>
                                </tr>
                                <tr style="text-align:left;">
                                    <td><span class="outputText2" style="font-weight:bold;">N° ANÁLISIS MICROBIOLOGICO</span></td><td><span class="outputText2" style="font-weight:bold;">:</span></td>
                                    <td><span class="outputText2" ><%=(nroMicro)%></span>
                                </tr>
                                
                                    <%
                                             DecimalFormatSymbols simbolo1=new DecimalFormatSymbols();
                                            simbolo1.setDecimalSeparator(',');
                                            simbolo1.setGroupingSeparator('.');
                                        DecimalFormat formatoMil = new DecimalFormat("###,###.##",simbolo1);
                                        formatoMil.setMaximumFractionDigits(2);
                                           consulta="select m.NOMBRE_CCC,cpc.CANTIDAD,um.ABREVIATURA,cpc.UNIDAD_PRODUCTO" +
                                                    ",cpc.NOMBRE_MATERIAL_EQUIVALENCIA,cpc.CANTIDAD_EQUIVALENCIA,isnull(ume.ABREVIATURA,'') as abreEquivalencia"+
                                                     " from COMPONENTES_PROD_CONCENTRACION cpc inner join materiales m"+
                                                     " on cpc.COD_MATERIAL=m.COD_MATERIAL inner join UNIDADES_MEDIDA um on "+
                                                     " um.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA" +
                                                     " left outer join UNIDADES_MEDIDA ume on ume.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA"+
                                                     " where cpc.COD_ESTADO_REGISTRO=1 and cpc.COD_COMPPROD='"+codComprod+"'" +
                                                     " and cpc.COD_VERSION='"+codVersion+"' and cpc.EXCIPIENTE<>1"+
                                                     " order by m.NOMBRE_CCC";
                                            System.out.println("consulta concentracion "+consulta);
                                            res=st.executeQuery(consulta);
                                            String concentracion="";
                                            String porUnidadProd="";
                                            if(res.next())
                                            {
                                                concentracion=res.getString("NOMBRE_CCC")+" "+formatoMil.format(res.getDouble("CANTIDAD"))+" "+res.getString("ABREVIATURA");
                                                //concentracion+=(res.getInt("CANTIDAD_EQUIVALENCIA")>0?(" equivalente a "+res.getString("NOMBRE_MATERIAL_EQUIVALENCIA")+" "+formatoMil.format(res.getDouble("CANTIDAD_EQUIVALENCIA"))+" "+res.getString("abreEquivalencia")):"");
                                                porUnidadProd=res.getString("UNIDAD_PRODUCTO");
                                            }
                                            while(res.next())
                                            {
                                                concentracion+=", "+res.getString("NOMBRE_CCC")+" "+formatoMil.format(res.getDouble("CANTIDAD"))+" "+res.getString("ABREVIATURA");//res.getString("datoMaterial");
                                                //concentracion+=(res.getInt("CANTIDAD_EQUIVALENCIA")>0?(" equivalente a "+res.getString("NOMBRE_MATERIAL_EQUIVALENCIA")+" "+formatoMil.format(res.getDouble("CANTIDAD_EQUIVALENCIA"))+" "+res.getString("abreEquivalencia")):"");
                                            }
                                            concentracion+=(porUnidadProd.equals("")?"":" / ")+porUnidadProd;
                                            if(!concentracion.equals(""))
                                                {
                                                %>
                                                <tr style="text-align:left;">
                                                    <td ><span class="outputText2" style="font-weight:bold;">CONCENTRACION</span></td><td><span class="outputText2" style="font-weight:bold;">:</span></td>
                                                    <td colspan="4" ><span class="outputText2" ><%=concentracion%></span>
                                                </tr>
                                                <%
                                            }
                                    %>
                                    
                            </table>

                        </div>
                    </div>
                    
                       
                      <br><%=(tablaFechasAcond)%></br><%=(tablaFechasApt)%></br>
                      <table cellpadding="0" cellspacing="0" >
                          <tr><td><span class="outputText2">Resultado fuera de especificación</span></td><td style="border:1px solid black;background-color:#FAEBD7;width:7em;">&nbsp;</td></tr>
                      </table>
                      <table class="outputText0" style="border : solid #cccccc 1px;" cellpadding="0" cellspacing="0" id="tablaDetalle">

                        <tr >
                                     <td class="headerClassACliente border"style='border:1px solid #cccccc;padding:8px'><h:outputText value="ANALISIS FISICO"/></td>
                                     <td class="headerClassACliente border" style='border:1px solid #cccccc;padding:8px'><h:outputText value="ESPECIFICACIONES"/></td>
                                     <td class="headerClassACliente border" style='border:1px solid #cccccc;padding:8px'><h:outputText value="REFERENCIA"/></td>
                                     <td class="headerClassACliente border" style='border:1px solid #cccccc;padding:8px'><h:outputText value="RESULTADOS"/></td>
                         </tr>
                         <%
                            String dictamen="";
                            
                            out.println("<input type='hidden' value='"+managed.getResultadoAnalisisBean().getCodLote()+"'/>");
                            out.println("<input type='hidden' value='"+managed.getResultadoAnalisisBean().getComponenteProd().getCodCompprod()+"'/>");
                            consulta="select rae.COD_TIPO_RESULTADO_DESCRIPTIVO,efcc.NOMBRE_ESPECIFICACION,efp.LIMITE_INFERIOR,efp.LIMITE_SUPERIOR,efp.VALOR_EXACTO," +
                                    "efp.DESCRIPCION,tr.NOMBRE_REFERENCIACC,isnull(trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,'') as NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,"+
                                     " rae.RESULTADO_NUMERICO,efcc.COD_TIPO_RESULTADO_ANALISIS," +
                                     "ISNULL(tra.SIMBOLO,'')as SIMBOLO,ISNULL(efcc.COEFICIENTE,'') as COEFICIENTE,ISNULL(efcc.unidad,'') as unidad"+
                                     " from ESPECIFICACIONES_FISICAS_PRODUCTO efp inner join ESPECIFICACIONES_FISICAS_CC efcc"+
                                     " on efp.COD_ESPECIFICACION=efcc.COD_ESPECIFICACION inner join TIPOS_REFERENCIACC tr on"+
                                     " tr.COD_REFERENCIACC=efp.COD_REFERENCIA_CC "+
                                     " inner join RESULTADO_ANALISIS_ESPECIFICACIONES rae on rae.COD_TIPO_ANALISIS=1"+
                                     " and rae.COD_COMPPROD=efp.COD_PRODUCTO" +
                                     " and  rae.COD_ESPECIFICACION=efcc.COD_ESPECIFICACION left outer join TIPO_RESULTADO_DESCRIPTIVO trd"+
                                     " on trd.COD_TIPO_RESULTADO_DESCRIPTIVO=rae.COD_TIPO_RESULTADO_DESCRIPTIVO" +
                                     " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=efcc.COD_TIPO_RESULTADO_ANALISIS"+
                                     " where efp.COD_PRODUCTO='"+managed.getResultadoAnalisisBean().getComponenteProd().getCodCompprod()+"'"+
                                     " and rae.COD_LOTE='"+managed.getResultadoAnalisisBean().getCodLote()+"'" +
                                     " and efp.COD_VERSION='"+codVersion+"' order by efcc.NOMBRE_ESPECIFICACION";
                            System.out.println("consulta analisis fisico "+consulta);
                           
                            String nombreAnalisis="";
                            String nombreReferencia="";
                            String nombreEspecificacion="";
                            String resultado="";
                            String codEspecificacion="";
                            String nombreMaterial="";
                            boolean aprobado=true;
                            Statement stdetalle=null;
                            ResultSet resdetalle=null;
                            res=st.executeQuery(consulta);
                                    double limiteSuperior=0d;
                                    double limiteInferior=0d;
                                    double valorExacto=0d;
                                    double resultadoNumerico=0d;
                                    String codTipoResultadoAnalisis="";
                                    String simbolo="";
                                    String coeficiente="";
                                    String unidad="";
                                    String descripcion="";
                                    boolean conExponente=false;
                                    String nombreTipoResultado="";
                                    boolean especificacionpAprobada=true;
                                    while(res.next())
                                    {
                                        nombreAnalisis=res.getString("NOMBRE_ESPECIFICACION");
                                        codTipoResultadoAnalisis=res.getString("COD_TIPO_RESULTADO_ANALISIS");
                                        nombreReferencia=res.getString("NOMBRE_REFERENCIACC");
                                        limiteInferior=res.getDouble("LIMITE_INFERIOR");
                                        limiteSuperior=res.getDouble("LIMITE_SUPERIOR");
                                        valorExacto=res.getDouble("VALOR_EXACTO");
                                        resultadoNumerico=res.getDouble("RESULTADO_NUMERICO");
                                        simbolo=res.getString("SIMBOLO");
                                        coeficiente=res.getString("COEFICIENTE");
                                        unidad=res.getString("unidad");
                                        nombreTipoResultado=res.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO");
                                        nombreEspecificacion=((codTipoResultadoAnalisis.equals("1")?res.getString("DESCRIPCION"):
                                            (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" "+unidad+"-"+String.valueOf(limiteSuperior)+" "+unidad):
                                            (coeficiente+" "+simbolo+" "+String.valueOf(valorExacto)+" "+unidad))));
                                        resultado=(codTipoResultadoAnalisis.equals("1")?nombreTipoResultado:(String.valueOf(resultadoNumerico)+" "+unidad+(nombreTipoResultado.equals("")?"":("("+nombreTipoResultado+")"))));
                                        especificacionpAprobada=true;
                                        if(!verificarResultadoAprobar(codTipoResultadoAnalisis,res.getString("COD_TIPO_RESULTADO_DESCRIPTIVO"), resultadoNumerico, limiteSuperior, limiteInferior, valorExacto))
                                        {
                                            especificacionpAprobada=false;
                                            aprobado=false;
                                        }


                                    %>
                                     <tr style="<%=(especificacionpAprobada?"":"background-color:#FAEBD7")%>">
                                        <td class="border"  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=nombreAnalisis%></span></td>
                                        <td class="border"  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=nombreEspecificacion%></span></td>
                                        <td class="border"  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=nombreReferencia%></span></td>
                                        <td class="border"  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=(resultado)%></span></td>
                                       </tr>
                                    <%
                                    }

                                    %>
                                  <tr bgcolor="#dddddd">
                                        <td class='dr-table-subheadercell rich-table-subheadercell headerClassACliente' align='center' style='border:1px solid #cccccc;padding:8px' colspan="4"><span class="outputText2"><b>ANALISIS QUIMICO</b></span></td>
                                  </tr>
                                  <%
                                  consulta="select eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS," +
                                           " ISNULL(eqcc.COEFICIENTE,'') as COEFICIENTE,ISNULL(tra.SIMBOLO,'') as SIMBOLO,ISNULL(eqcc.UNIDAD,'') AS unidad"+
                                           " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp inner join"+
                                           " ESPECIFICACIONES_QUIMICAS_CC eqcc on eqp.COD_ESPECIFICACION=eqcc.COD_ESPECIFICACION" +
                                           " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=eqcc.COD_TIPO_RESULTADO_ANALISIS"+
                                           " where eqp.COD_PRODUCTO='"+managed.getResultadoAnalisisBean().getComponenteProd().getCodCompprod()+"'  and eqp.ESTADO=1 " +
                                           " and eqp.COD_VERSION='"+codVersion+"'"+
                                           " group by eqcc.UNIDAD,eqcc.COD_ESPECIFICACION,eqcc.NOMBRE_ESPECIFICACION,eqcc.COD_TIPO_RESULTADO_ANALISIS,eqcc.COEFICIENTE,tra.SIMBOLO";
                                  System.out.println("consulta especificaciones quimicas "+consulta);
                                  stdetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

                                  res=st.executeQuery(consulta);
                                  while(res.next())
                                  {
                                      unidad=res.getString("unidad");
                                      coeficiente=res.getString("COEFICIENTE");
                                      simbolo=res.getString("SIMBOLO");
                                      nombreAnalisis=res.getString("NOMBRE_ESPECIFICACION");
                                      codEspecificacion=res.getString("COD_ESPECIFICACION");
                                      codTipoResultadoAnalisis=res.getString("COD_TIPO_RESULTADO_ANALISIS");
                                       consulta="select eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,eqp.VALOR_EXACTO,"+
                                               " tr.NOMBRE_REFERENCIACC,raeq.RESULTADO_NUMERICO,"+
                                               " isnull(trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,'') as NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,trd.COD_TIPO_RESULTADO_DESCRIPTIVO"+
                                               " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp "+
                                               " inner join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=eqp.COD_REFERENCIA_CC"+
                                               " inner join RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS raeq on "+
                                               " raeq.COD_ESPECIFICACION=eqp.COD_ESPECIFICACION and raeq.COD_MATERIAL=eqp.COD_MATERIAL " +
                                               " and raeq.COD_COMPPROD=eqp.COD_PRODUCTO"+
                                               " left outer join TIPO_RESULTADO_DESCRIPTIVO trd on trd.COD_TIPO_RESULTADO_DESCRIPTIVO=raeq.COD_TIPO_RESULTADO_DESCRIPTIVO"+
                                               " where eqp.COD_ESPECIFICACION='"+codEspecificacion+"' and eqp.COD_PRODUCTO='"+managed.getResultadoAnalisisBean().getComponenteProd().getCodCompprod()+"' and eqp.ESTADO=1"+
                                               " and raeq.COD_LOTE='"+managed.getResultadoAnalisisBean().getCodLote()+"' and eqp.COD_MATERIAL=-1" +
                                               " and eqp.COD_VERSION='"+codVersion+"'";
                                       System.out.println("consulta detalle general "+consulta);
                                       resdetalle=stdetalle.executeQuery(consulta);
                                       if(resdetalle.next())
                                       {
                                           especificacionpAprobada=true;
                                           nombreReferencia=resdetalle.getString("NOMBRE_REFERENCIACC");
                                                  limiteInferior=resdetalle.getDouble("LIMITE_INFERIOR");
                                                  limiteSuperior=resdetalle.getDouble("LIMITE_SUPERIOR");
                                                  valorExacto=resdetalle.getDouble("VALOR_EXACTO");
                                                  resultadoNumerico=resdetalle.getDouble("RESULTADO_NUMERICO");
                                                  nombreTipoResultado=resdetalle.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO");
                                                  nombreEspecificacion=(codTipoResultadoAnalisis.equals("1")?resdetalle.getString("DESCRIPCION"):
                                                       (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" "+unidad+ "-"+String.valueOf(limiteSuperior)+" "+unidad) :
                                                        (coeficiente+" "+simbolo+" "+String.valueOf(valorExacto)+" "+unidad)));
                                                   resultado=(codTipoResultadoAnalisis.equals("1")?nombreTipoResultado:
                                                       (String.valueOf(resultadoNumerico)+" "+unidad+(nombreTipoResultado.equals("")?"":("("+nombreTipoResultado+")"))));
                                                    if(!verificarResultadoAprobar(codTipoResultadoAnalisis, resdetalle.getString("COD_TIPO_RESULTADO_DESCRIPTIVO"),
                                                    resultadoNumerico, limiteSuperior, limiteInferior, valorExacto))
                                                    {
                                                        especificacionpAprobada=false;
                                                        aprobado=false;
                                                    }
                                                   %>
                                                <tr style="<%=(especificacionpAprobada?"":"background-color:#FAEBD7")%>" >
                                                    <td class="border"  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><b><%=nombreAnalisis%></b></span></td>
                                                    <td class="border"  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=nombreEspecificacion%></span></td>
                                                    <td class="border"  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=nombreReferencia%></span></td>
                                                    <td class="border"  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=resultado%></span></td>
                                                </tr>
                                                <%
                                       }
                                       else
                                       {
                                              %>
                                              <tr bgcolor="#eeeeee" >
                                                <td class="border" colspan="4" style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><b><%=nombreAnalisis%></b></span></td>
                                                </tr>
                                              <%
                                              consulta="select case when eqp.COD_MATERIAL>0 and eqp.COD_MATERIAL<>-1 then m.NOMBRE_CCC else mcc.NOMBRE_MATERIAL_COMPUESTO_CC end as NOMBRE_CCC,eqp.DESCRIPCION,eqp.LIMITE_INFERIOR,eqp.LIMITE_SUPERIOR,eqp.VALOR_EXACTO,"+
                                                       " tr.NOMBRE_REFERENCIACC,raeq.RESULTADO_NUMERICO,"+
                                                       " isnull(trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,'') as NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,trd.COD_TIPO_RESULTADO_DESCRIPTIVO"+
                                                       " from ESPECIFICACIONES_QUIMICAS_PRODUCTO eqp left outer join MATERIALES m  on m.COD_MATERIAL=eqp.COD_MATERIAL " +
                                                       " left outer join MATERIALES_COMPUESTOS_CC mcc on mcc.COD_MATERIAL_COMPUESTO_CC=eqp.COD_MATERIAL_COMPUESTO_CC" +
                                                       " inner join TIPOS_REFERENCIACC tr on tr.COD_REFERENCIACC=eqp.COD_REFERENCIA_CC"+
                                                       " inner join RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS raeq on "+
                                                       " raeq.COD_ESPECIFICACION=eqp.COD_ESPECIFICACION and raeq.COD_MATERIAL=eqp.COD_MATERIAL and raeq.COD_MATERIAL_COMPUESTO_CC=eqp.COD_MATERIAL_COMPUESTO_CC"+
                                                       " and raeq.COD_COMPPROD=eqp.COD_PRODUCTO"+
                                                       " left outer join TIPO_RESULTADO_DESCRIPTIVO trd on trd.COD_TIPO_RESULTADO_DESCRIPTIVO=raeq.COD_TIPO_RESULTADO_DESCRIPTIVO"+
                                                       " where eqp.COD_ESPECIFICACION='"+codEspecificacion+"' and eqp.COD_PRODUCTO='"+managed.getResultadoAnalisisBean().getComponenteProd().getCodCompprod()+"' and eqp.ESTADO=1"+
                                                       " and raeq.COD_LOTE='"+managed.getResultadoAnalisisBean().getCodLote()+"'" +
                                                       " and eqp.COD_VERSION='"+codVersion+"' order by m.NOMBRE_CCC";
                                              System.out.println("consulta detalle analisis quimicos "+consulta);

                                              resdetalle=stdetalle.executeQuery(consulta);
                                              while(resdetalle.next())
                                              {
                                                  especificacionpAprobada=true;
                                                  nombreMaterial=resdetalle.getString("NOMBRE_CCC");
                                                  nombreReferencia=resdetalle.getString("NOMBRE_REFERENCIACC");
                                                  limiteInferior=resdetalle.getDouble("LIMITE_INFERIOR");
                                                  limiteSuperior=resdetalle.getDouble("LIMITE_SUPERIOR");
                                                  valorExacto=resdetalle.getDouble("VALOR_EXACTO");
                                                  resultadoNumerico=resdetalle.getDouble("RESULTADO_NUMERICO");
                                                  nombreTipoResultado=resdetalle.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO");
                                                   nombreEspecificacion=(codTipoResultadoAnalisis.equals("1")?resdetalle.getString("DESCRIPCION"):
                                                       (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" "+unidad+ "-"+String.valueOf(limiteSuperior)+" "+unidad) :
                                                        (coeficiente+" "+simbolo+" "+String.valueOf(valorExacto)+" "+unidad)));
                                                   resultado=(codTipoResultadoAnalisis.equals("1")?nombreTipoResultado:
                                                       (String.valueOf(resultadoNumerico)+" "+unidad+(nombreTipoResultado.equals("")?"":("("+nombreTipoResultado+")"))));
                                                    if(!verificarResultadoAprobar(codTipoResultadoAnalisis, resdetalle.getString("COD_TIPO_RESULTADO_DESCRIPTIVO"),
                                                    resultadoNumerico, limiteSuperior, limiteInferior, valorExacto))
                                                    {
                                                        especificacionpAprobada=false;
                                                        aprobado=false;
                                                    }
                                                   %>
                                                <tr style="<%=(especificacionpAprobada?"":"background-color:#FAEBD7")%>" >
                                                    <td class="border"  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=nombreMaterial%></span></td>
                                                    <td class="border"  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=nombreEspecificacion%></span></td>
                                                    <td class="border"  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=nombreReferencia%></span></td>
                                                    <td class="border"  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=resultado%></span></td>
                                                </tr>
                                              <%

                                              }
                                      }
                                      resdetalle.close();

                                  }

                                  stdetalle.close();
                                  if(!concentracion.equals(""))
                                  {
                                          consulta="select m.NOMBRE_CCC,rae.RESULTADO_NUMERICO,cpc.CANTIDAD,um.ABREVIATURA" +
                                                    ",cpc.NOMBRE_MATERIAL_EQUIVALENCIA,cpc.CANTIDAD_EQUIVALENCIA,isnull(ume.ABREVIATURA,'') as abreEquivalencia"+
                                                    " from RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS rae inner join"+
                                                    " materiales m on m.COD_MATERIAL=rae.COD_MATERIAL inner join"+
                                                    " COMPONENTES_PROD_CONCENTRACION cpc on cpc.COD_COMPPROD='"+codComprod+"' and "+
                                                    " rae.COD_MATERIAL=cpc.COD_MATERIAL and cpc.COD_ESTADO_REGISTRO=1" +
                                                    " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA"+
                                                    " left outer join UNIDADES_MEDIDA ume on ume.COD_UNIDAD_MEDIDA=cpc.COD_UNIDAD_MEDIDA_EQUIVALENCIA"+
                                                    " where rae.COD_COMPPROD=cpc.COD_COMPPROD and rae.COD_ESPECIFICACION=2 and rae.COD_TIPO_RESULTADO_DESCRIPTIVO not in (1,2)"+
                                                    " and rae.COD_LOTE='"+managed.getResultadoAnalisisBean().getCodLote()+"'"+
                                                    " and cpc.COD_VERSION='"+codVersion+"' and cpc.EXCIPIENTE<>1"+
                                                    " order by m.NOMBRE_CCC";
                                          System.out.println("consulta concentracion "+consulta);
                                          res=st.executeQuery(consulta);
                                          String datoQuimico="";

                                          while(res.next())
                                          {
                                              datoQuimico+=(datoQuimico.equals("")?"":"; ")+res.getString("NOMBRE_CCC")+" "+formatoMil.format((res.getDouble("CANTIDAD")/100)*res.getDouble("RESULTADO_NUMERICO"))+" "+res.getString("ABREVIATURA");
                                              //datoQuimico+=(res.getInt("CANTIDAD_EQUIVALENCIA")>0?(" equivalente a "+res.getString("NOMBRE_MATERIAL_EQUIVALENCIA")+" "+formatoMil.format((res.getDouble("CANTIDAD_EQUIVALENCIA")/100)*res.getDouble("RESULTADO_NUMERICO"))+" "+res.getString("abreEquivalencia")):"");
                                          }
                                          consulta="select m1.NOMBRE_CCC,m2.NOMBRE_CCC as NOMBRE_CCC2,mcc.COD_MATERIAL_COMPUESTO_CC,"+
                                                   "rae.RESULTADO_NUMERICO, cpc1.CANTIDAD,cpc2.CANTIDAD as cantidad2,um1.ABREVIATURA,um2.ABREVIATURA as abreviatura2"+
                                                    ",mcc.PORCIENTO_RESULTADO_MATERIAL_1,mcc.PORCIENTO_RESULTADO_MATERIAL_2"+
                                                    " from RESULTADO_ANALISIS_ESPECIFICACIONES_QUIMICAS rae inner join MATERIALES_COMPUESTOS_CC mcc"+
                                                    " on mcc.COD_MATERIAL_COMPUESTO_CC=rae.COD_MATERIAL_COMPUESTO_CC inner join "+
                                                    " materiales m1 on m1.COD_MATERIAL=mcc.COD_MATERIAL_1 inner join"+
                                                    " materiales m2 on m2.COD_MATERIAL=mcc.COD_MATERIAL_2 "+
                                                    " inner join  COMPONENTES_PROD_CONCENTRACION cpc1 on cpc1.COD_MATERIAL=m1.COD_MATERIAL "+
                                                    " inner join COMPONENTES_PROD_CONCENTRACION cpc2 on cpc2.COD_MATERIAL=m2.COD_MATERIAL "+
                                                    " inner join UNIDADES_MEDIDA um1 on um1.COD_UNIDAD_MEDIDA=cpc1.COD_UNIDAD_MEDIDA inner join"+
                                                    " UNIDADES_MEDIDA um2 on um2.COD_UNIDAD_MEDIDA=cpc2.COD_UNIDAD_MEDIDA"+
                                                    " where rae.COD_COMPPROD='"+codComprod+"' and rae.COD_ESPECIFICACION=2 and rae.COD_TIPO_RESULTADO_DESCRIPTIVO not IN(1,2)"+
                                                    " and rae.cod_lote='"+managed.getResultadoAnalisisBean().getCodLote()+"' and rae.COD_MATERIAL=0 and rae.COD_MATERIAL_COMPUESTO_CC>0"+
                                                    " and cpc1.COD_COMPPROD='"+codComprod+"' and cpc2.COD_COMPPROD='"+codComprod+"'" +
                                                    " and cpc1.COD_VERSION='"+codVersion+"'" +
                                                    " and cpc2.COD_VERSION='"+codVersion+"'";
                                          System.out.println("consulta cargar concentracion materiales compuestos "+consulta);
                                          res=st.executeQuery(consulta);
                                          while(res.next())
                                          {
                                              datoQuimico+=(datoQuimico.equals("")?"":"; ")+res.getString("NOMBRE_CCC")+" "+formatoMil.format((res.getDouble("CANTIDAD")*res.getDouble("RESULTADO_NUMERICO"))/100)+" "+res.getString("ABREVIATURA");
                                              datoQuimico+=(datoQuimico.equals("")?"":"; ")+res.getString("NOMBRE_CCC2")+" "+formatoMil.format((res.getDouble("CANTIDAD2")*res.getDouble("RESULTADO_NUMERICO"))/100)+" "+res.getString("ABREVIATURA");
                                              
                                          }

                                          out.println("<tr><td style='border:1px solid #dddddd;padding:8px' class='border' align='left' colspan='4'><span class='outputText2'>Corresponde a "+datoQuimico+(porUnidadProd.equals("")?"":"/"+porUnidadProd)+"</span></td></tr>");
                                   }
                              %>
                                 
                       
                         <tr bgcolor="#dddddd">
                                <td class="headerClassACliente border" style='border:1px solid #cccccc;padding:8px' colspan="4"><span class="outputText2"><b>ANALISIS MICROBIOLOGICO</b>(Control de Esterilidad)</span></td>
                          </tr>
                         <%
                         consulta="select em.NOMBRE_ESPECIFICACION,emp.LIMITE_INFERIOR,emp.LIMITE_SUPERIOR,emp.VALOR_EXACTO,emp.DESCRIPCION,tr.NOMBRE_REFERENCIACC,isnull(trd.NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,'') as NOMBRE_TIPO_RESULTADO_DESCRIPTIVO,"+
                                  " rae.RESULTADO_NUMERICO,em.COD_TIPO_RESULTADO_ANALISIS,ISNULL(em.COEFICIENTE,'') as COEFICIENTE,ISNULL(tra.SIMBOLO,'') as SIMBOLO,trd.COD_TIPO_RESULTADO_DESCRIPTIVO" +
                                  " ,ISNULL(em.unidad,'') as unidad"+
                                  " from ESPECIFICACIONES_MICROBIOLOGIA_PRODUCTO emp inner join ESPECIFICACIONES_MICROBIOLOGIA em on "+
                                  " emp.COD_ESPECIFICACION = em.COD_ESPECIFICACION inner join TIPOS_REFERENCIACC tr on "+
                                  " tr.COD_REFERENCIACC = emp.COD_REFERENCIA_CC inner join RESULTADO_ANALISIS_ESPECIFICACIONES rae on"+
                                  " rae.COD_TIPO_ANALISIS = 3 and rae.COD_COMPPROD=emp.COD_COMPROD and  "+
                                  " rae.COD_ESPECIFICACION = emp.COD_ESPECIFICACION left outer JOIN TIPO_RESULTADO_DESCRIPTIVO trd on "+
                                  " trd.COD_TIPO_RESULTADO_DESCRIPTIVO=rae.COD_TIPO_RESULTADO_DESCRIPTIVO" +
                                  " left outer join TIPOS_RESULTADOS_ANALISIS tra on tra.COD_TIPO_RESULTADO_ANALISIS=em.COD_TIPO_RESULTADO_ANALISIS"+
                                  " where emp.COD_COMPROD = '"+managed.getResultadoAnalisisBean().getComponenteProd().getCodCompprod()+"' "+
                                  " and rae.COD_LOTE='"+managed.getResultadoAnalisisBean().getCodLote()+"'" +
                                  " and emp.COD_VERSION='"+codVersion+"'" +
                                  " order by em.NOMBRE_ESPECIFICACION";
                         System.out.println("consulta detalle microbiologia "+consulta);
                         res=st.executeQuery(consulta);
                         while(res.next())
                             {
                                especificacionpAprobada=true;
                                unidad=res.getString("unidad");
                                nombreAnalisis=res.getString("NOMBRE_ESPECIFICACION");
                                codTipoResultadoAnalisis=res.getString("COD_TIPO_RESULTADO_ANALISIS");
                                nombreReferencia=res.getString("NOMBRE_REFERENCIACC");
                                limiteInferior=res.getDouble("LIMITE_INFERIOR");
                                limiteSuperior=res.getDouble("LIMITE_SUPERIOR");
                                resultadoNumerico=res.getDouble("RESULTADO_NUMERICO");
                                valorExacto=res.getDouble("VALOR_EXACTO");
                                simbolo=res.getString("SIMBOLO");
                                coeficiente=res.getString("COEFICIENTE");
                                descripcion=res.getString("DESCRIPCION");
                                nombreTipoResultado=res.getString("NOMBRE_TIPO_RESULTADO_DESCRIPTIVO");

                                 resultado=(codTipoResultadoAnalisis.equals("1")?nombreTipoResultado:
                                                       (String.valueOf(resultadoNumerico)+" "+unidad+(nombreTipoResultado.equals("")?"":("("+nombreTipoResultado+")"))));



                                nombreEspecificacion=(codTipoResultadoAnalisis.equals("1")?descripcion:
                                    (codTipoResultadoAnalisis.equals("2")?(String.valueOf(limiteInferior)+" "+unidad+"-"+String.valueOf(limiteSuperior)+" "+unidad):
                                    (coeficiente+" "+simbolo+" "+valorExacto+" "+unidad)));
                                resultado=(codTipoResultadoAnalisis.equals("1")?nombreTipoResultado:
                                    String.valueOf(resultadoNumerico)+" "+unidad+(nombreTipoResultado.equals("")?"":("("+nombreTipoResultado+")")));
                                if(!verificarResultadoAprobar(codTipoResultadoAnalisis,res.getString("COD_TIPO_RESULTADO_DESCRIPTIVO"), resultadoNumerico, limiteSuperior, limiteInferior, valorExacto))
                                {
                                    especificacionpAprobada=false;
                                    aprobado=false;
                                }
                                conExponente=(descripcion.split("\\^").length>1);


                                %>
                             <tr style="<%=(especificacionpAprobada?"":"background-color:#FAEBD7")%>" >
                                <td class="border"  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=nombreAnalisis%></span></td>
                                <%
                                if(conExponente)
                                {
                                    out.println("<td class='border'  style='border:1px solid #dddddd;padding:8px'><span class='outputText2'><div style='position:relative;'>"+descripcion.split("\\^")[0]+"<span style='font-size:7px;position:absolute;top:0;rigth:20px'>"+descripcion.split("\\^")[1]+"</span></div></span></td>");
                                    }
                                else
                                    {
                                        out.println("<td class='border'  style='border:1px solid #dddddd;padding:8px'><span class='outputText2'>"+nombreEspecificacion+"</span></td>");
                                }

                                %>

                                <td class='border'  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=nombreReferencia%></span></td>
                                <td class='border'  style='border:1px solid #dddddd;padding:8px'><span class="outputText2"><%=resultado%></span></td>
                               </tr>
                            <%
                             }
                       
                        String observacion="";
                        
                        if(aprobado)
                        {
                            observacion="Resultado de análisis dentro de los límites";
                            dictamen="APROBADO";
                        }
                        else
                        {
                            observacion="Resultado de análisis fuera de los límites";
                            dictamen="RECHAZADO";
                        }
                         %>

                        </table>
                        <span class="outputText2">Estado segun sistema :&nbsp;&nbsp;</span><span><b><%=dictamen%></b></span><br>
                        <span class="outputText2">Estado actual :&nbsp;&nbsp;</span><span><b><%=(managed.getResultadoAnalisisBean().getEstadoResultadoAnalisis().getNombreEstadoResultadoAnalisis())%></b></span>
                    <%
                    StringBuilder consulta1=new StringBuilder("SELECT fcc.URL_FIRMA,('Dra. '+p.NOMBRE_PILA+' '+p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL) as jefe");
                                            consulta1.append(" FROM PERSONAL_JEFE_AREA_PRODUCCION pjap inner join personal p on ");
                                            consulta1.append(" p.COD_PERSONAL=pjap.COD_PERSONAL");
                                            consulta1.append(" inner join FIRMAS_CERTIFICADO_CC fcc on fcc.COD_PERSONAL=p.COD_PERSONAL");
                                            consulta1.append(" where pjap.COD_ESTADO_REGISTRO=1 and pjap.COD_AREA_EMPRESA=40");
                        res=st.executeQuery(consulta1.toString());
                        while(res.next())
                        {
                            nombreJefeControldeCalidad=res.getString("jefe");
                        }
                            }
                            catch(SQLException ex)
                            {
                                ex.printStackTrace();
                            }
                         %>
                         <table width="90%" align="center" style="margin-top:12px">
                          <tr>
                                <td  align='right'  ><span class="outputText2"><b>Fecha Revisión:</b></span></td>
                                <td  align='left' >
                                    <h:panelGroup>
                                        <h:inputText value="#{ManagedResultadoAnalisis.resultadoAnalisisBean.fechaRevision}"   styleClass="outputText2"  id="fechaRevision"  size="15" onblur="valFecha(this);" >
                                    <f:convertDateTime pattern="dd/MM/yyyy"   />
                                </h:inputText>
                                <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha1" />
                                <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:fechaRevision\" click_element_id=\"form1:imagenFecha1\"></DLCALENDAR>"  escape="false"  />
                            </h:panelGroup>
                                     </td>
                                <td  align='right'  ><span class="outputText2"><b>Fecha Emisión:</b></span></td>
                                <td  align='left' ><h:panelGroup>
                                    <h:inputText value="#{ManagedResultadoAnalisis.resultadoAnalisisBean.fechaEmision}"   styleClass="outputText2"  id="fechaEmision"  size="15" onblur="valFecha(this);" >
                                    <f:convertDateTime pattern="dd/MM/yyyy"   />
                                </h:inputText>
                                <h:graphicImage url="../img/fecha.bmp"  id="imagenFecha2" />
                                <h:outputText value="<DLCALENDAR tool_tip=\"Seleccione la Fecha\"  daybar_style=\"background-color: DBE1E7;font-family: verdana; color:000000;\"    navbar_style=\"background-color: 7992B7; color:ffffff;\"  input_element_id=\"form1:fechaEmision\" click_element_id=\"form1:imagenFecha2\"></DLCALENDAR>"  escape="false"  />
                            </h:panelGroup></td>

                            </tr>
                        </table>

                         <table width="90%" align="center" style="margin-top:12px">
                          <tr>
                                <td  align='center'  ><span class="outputText2"><b>Analista</b></span></td>
                                <td  align='center' ><span class="outputText2"><b>Jefe Control de Calidad:&nbsp;</b></span></td>

                            </tr>
                             <tr>
                                <td  align='center'  ><span class="outputText2"><%=nombreAnalista%></span></td>
                                <td  align='center' ><span class="outputText2"><%=nombreJefeControldeCalidad%></span></td>

                            </tr>
                        </table>
                    <br></br>
                    <a4j:commandButton action="#{ManagedResultadoAnalisis.aprobarResultadoAnalisis_action}" value="Aprobar" styleClass="btn" 
                    oncomplete="if(#{ManagedResultadoAnalisis.mensaje eq '1'}){var a=new Date();window.location='navegadorResultadosRegistrados.jsf?apro='+a.getTime().toString();alert('Se aprobo el certificado');}else{alert('#{ManagedResultadoAnalisis.mensaje}');}"/>
                    <a4j:commandButton action="#{ManagedResultadoAnalisis.rechazarResultadoAnalisis_action}" value="Rechazar" styleClass="btn" 
                    oncomplete="if(#{ManagedResultadoAnalisis.mensaje eq '1'}){var a=new Date();window.location='navegadorResultadosRegistrados.jsf?recha='+a.getTime().toString();alert('Se rechazo el certificado');}else{alert('#{ManagedResultadoAnalisis.mensaje}')}"/>
                    <a4j:commandButton  value="Cancelar" styleClass="btn" onclick="var a=new Date();window.location='navegadorResultadosRegistrados.jsf?cancel='+a.getTime().toString();"/>
                    </div>
                    <br/>
           </a4j:form>
            <a4j:status id="statusPeticion"
                        onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                        onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
            </a4j:status>
            <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                             minWidth="200" height="80" width="400" zindex="100" onshow="window.focus();">

                <div align="center">
                    <h:graphicImage value="../img/load2.gif" />
                </div>
            </rich:modalPanel>
           <script type="text/javascript" language="JavaScript"  src="../js/dlcalendar.js" ></script>
        </body>
    </html>
    
</f:view>

