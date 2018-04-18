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
<%@ page import = "java.util.List"%>
<%@ page import = "java.util.Date"%> 
<%@ page import = "javax.servlet.http.HttpServletRequest"%>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>
<%@page import="java.awt.Point" %>
<%@ page language="java" import = "org.joda.time.*"%>
<%@ page language="java" import="java.util.*,com.cofar.util.CofarConnection" %>



<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<html>
   <head>
<script type="text/javascript" src="libJs/joint.all.min.js"></script>
<link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
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
    .normal
    {
        font-weight:400;
        font-family: 'Arial';
        font-size:12px;
        font-style:normal;

    }
    
</style>
<script>
  
</script>

</head>
    <body>
        <%
        int cantPixeles=0;
        try
        {
            Connection con=null;
            con=Util.openConnection(con);
            Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
            String codCompProd=request.getParameter("codComprod");
            String consulta1="select c.nombre_prod_semiterminado from COMPONENTES_PROD c where c.COD_COMPPROD ='"+codCompProd+"'";
            ResultSet res1=st.executeQuery(consulta1);
            String nombreComponente=request.getParameter("nombreProd");
            if(res1.next())
            {
                    nombreComponente=res1.getString("nombre_prod_semiterminado");
            }
        
        String nombreAreaEmpresa=request.getParameter("areaEmpresa");
        System.out.println("nombre "+nombreComponente);
        %>
        
        <center>

            <table align="center">
                <tr>
                    <th colspan="4"><center><span class="outputText2"><b>Diagrama de procesos</b></span></center></th>
                </tr>
                <tr>
                    <th rowspan="2" width="10%">
                            <img src="../../img/cofar.png">
                    </th>
                    <th align="right"><span class="outputText2"><b>Producto</b></span></th>
                    <th align="left"><span class="outputText2"><b>::</b></span></th>
                    <th align="left"><span class="outputText2" style="font-weight:normal"><%=nombreComponente%></span></th>
                    
                </tr>
                <tr>
                    <th align="right"><span class="outputText2"><b>Area Empresa</b></span></th>
                    <th align="left"><span class="outputText2"><b>::</b></span></th>
                    <th align="left"><span class="outputText2"style="font-weight:normal"><%=nombreAreaEmpresa%></span></th>
                </tr>
                </table>
                <br>
                <table>
                <tr>
                    <td><span class="outputText2"><b>Procesos:</b></span></td>
                    <td bgcolor="#87CEFA" style="width:100px;height:25px"></td>
                
                    <td><span class="outputText2"><b>Sub Procesos:</b></span></td>
                    <td bgcolor="#90EE90" style="width:100px;height:25px"></td>

                    <td><span class="outputText2"><b>Procesos Con Personal Disponible:</b></span></td>
                    <td bgcolor="#FFC0CB" style="width:100px;height:25px"></td>
                </tr>
            </table>
           
            <div id="diagrama"></div></center>

        <input type="hidden" value="<%=cantPixeles%>" id="tamTexto"/>
        <script type="text/javascript">
            
            var uml = Joint.dia.uml;
           var fd=Joint.point;
        <%
            char b=13;char c=10;
            String consulta="select pp.COD_PROCESO_PRODUCTO,pp.OPERARIO_TIEMPO_COMPLETO,pp.descripcion,pp.TIEMPO_PROCESO,pp.COD_PROCESO_PRODUCTO,pp.NRO_PASO,ap.NOMBRE_ACTIVIDAD_PREPARADO," +
                            " pp.TIEMPO_PROCESO_PERSONAL,pp.PORCIENTO_TOLERANCIA_TIEMPO_PROCESO"+
                            " from PROCESOS_PRODUCTO pp inner join ACTIVIDADES_PREPARADO ap on "+
                            " ap.COD_ACTIVIDAD_PREPARADO=pp.COD_ACTIVIDAD_PREPARADO "+
                            "  left outer JOIN maquinarias m on m.COD_MAQUINA=pp.COD_MAQUINA"+
                            " where pp.COD_COMPPROD="+codCompProd+" order by pp.NRO_PASO";
            System.out.println("consulta procesos prod "+consulta);
            ResultSet res=st.executeQuery(consulta);
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
            formatoNumero.applyPattern("#,##0.00");
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
            while(res.next())
            {
                cont2++;
                contNodoP++;
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
                consulta="select m.NOMBRE_MAQUINA,m.codigo,isnull(eea.NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE,'') as NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE,"+
                        " ISNULL(case WHEN td.COD_TIPO_DESCRIPCION = 1 THEN (case when ppeq.DATOS_NO_CONSOLIDADOS=0 then ppeq.VALOR_DESCRIPTIVO else '_______________' end )"+
                        " WHEN td.COD_TIPO_DESCRIPCION = 2 THEN (case when ppeq.DATOS_NO_CONSOLIDADOS=0 then CAST (ppeq.RANGO_INFERIOR"+
                        " as varchar) + ' - ' + cast (ppeq.RANGO_SUPERIOR as varchar) else '____-_____' end)"+
                        " else (case when ppeq.DATOS_NO_CONSOLIDADOS=0 then CAST (ppeq.VALOR_EXACTO as varchar)else '_____' end )"+
                        " end, '') as resultado,"+
                        " (case WHEN eea.COD_UNIDAD_MEDIDA>0 THEN um.ABREVIATURA"+
                        " WHEN eea.COD_UNIDAD_TIEMPO>0 THEN ut.ABREVIATURA "+
                        " WHEN eea.COD_UNIDAD_VELOCIDAD >0 then  uv.NOMBRE_UNIDAD_VELOCIDAD" +
                        " when eea.COD_UNIDAD_MEDIDA_TEMPERATURA>0 then umt.ABREVIATURA"+
                        " else '4'  end ) as unidad,ppeq.PORCIENTO_TOLERANCIA,(eea.TOLERANCIA*ppeq.VALOR_EXACTO) AS TOLERANCIA"+
                        " from PROCESOS_PRODUCTO_MAQUINARIA ppm inner join maquinarias m on "+
                        " m.COD_MAQUINA=ppm.COD_MAQUINA left outer join "+
                        " PROCESOS_PRODUCTO_ESP_EQUIP ppeq on"+
                        " ppm.COD_MAQUINA=ppeq.COD_MAQUINA and ppm.COD_PROCESO_PRODUCTO=ppeq.COD_PROCESO_PRODUCTO " +
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
                    especificaciones+=((especificaciones.equals("")?"":",")+"'"+resd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE")+"','"+
                            resd.getString("resultado")+" "+resd.getString("unidad")+" "+(resd.getDouble("TOLERANCIA")>0?(" ±"+formatoNumero.format(resd.getDouble("TOLERANCIA"))+" "+resd.getString("unidad")):"")+"'");
                    }
                }
                maquinariasDetalles+= cabecera.equals("")?"":((maquinariasDetalles.equals("")?"":",")+"['"+cabecera+"',["+especificaciones+"]]");
                consulta="select m.NOMBRE_MATERIAL,ppem.CANTIDAD ,um.ABREVIATURA"+//as porcenta,ppem.PORCIENTO_MATERIAL,fmd.CANTIDAD,
                         " from PROCESOS_PRODUCTO_ESP_MAT ppem " +
                         " inner join MATERIALES m on m.COD_MATERIAL=ppem.COD_MATERIAL"+
                         " inner join FORMULA_MAESTRA_DETALLE_MP fmd on fmd.COD_MATERIAL=ppem.COD_MATERIAL "+
                         " and fmd.COD_FORMULA_MAESTRA=ppem.COD_FORMULA_MAESTRA"+
                         " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA" +
                         " where ppem.COD_PROCESO_PRODUCTO='"+codProcesoProd+"'";
                        System.out.println("consulta materiales "+consulta);
                        resd=std.executeQuery(consulta);
                        materiales="";
                        while(resd.next())
                        {
                            cont++;
                            materiales+=((materiales.equals("")?"":",")+"'"+resd.getString("NOMBRE_MATERIAL")+"','"+
                                    resd.getString("CANTIDAD")+" ("+resd.getString("ABREVIATURA")+")'");//nf.format(resd.getDouble("CANTIDAD")*resd.getDouble("PORCIENTO_MATERIAL"))
                        }
                consulta="select spp.COD_PROCESO_PRODUCTO_DESTINO,spp.COD_SUB_PROCESO_PRODUCTO,spp.descripcion,spp.TIEMPO_SUB_PROCESO,spp.COD_SUB_PROCESO_PRODUCTO,ap.NOMBRE_ACTIVIDAD_PREPARADO,spp.NRO_PASO,"+
                         " spp.TIEMPO_SUB_PROCESO_PERSONAL,spp.PORCIENTO_TOLERANCIA_TIEMPO_SUB_PROCESO,spp.OPERARIO_TIEMPO_COMPLETO"+
                         " from SUB_PROCESOS_PRODUCTO spp inner join ACTIVIDADES_PREPARADO ap"+
                         " on spp.COD_ACTIVIDAD_PREPARADO=ap.COD_ACTIVIDAD_PREPARADO"+
                         " left outer join maquinarias m on m.COD_MAQUINA=spp.COD_MAQUINA"+
                         " where spp.COD_PROCESO_PRODUCTO='"+codProcesoProd+"'" +
                         " order by spp.NRO_PASO";
                System.out.println("consulta subprocesos "+consulta);
                resd=std.executeQuery(consulta);
                contNodoSubP=0;
                primerRegistro=true;
                subprocesoDer=true;
                 script+="var s"+codProcesoProd+" = uml.State.create({rect: {x:750, y: "+posYcen+", width: 400, height:"+(cont+(descripcion.equals("")?0:6))*18+"},"+
                        "label: '"+nroPasoProceso+"-Actividad:"+res.getString("NOMBRE_ACTIVIDAD_PREPARADO")+( tiempoProceso>0?"-Tiempo:"+tiempoProceso+
                        " min-Tolerancia:"+nf.format((res.getDouble("PORCIENTO_TOLERANCIA_TIEMPO_PROCESO")/100)*tiempoProceso)+" min":"")+" -Operario Tiempo Completo:"+(operarioTiempoCompletoProcesos>0?"SI":"NO")+
                        "',attrs: {fill:'90-#000-"+(operarioTiempoCompletoProcesos>0?"#87CEFA":"#FFC0CB")+":1-#fff'}," +
                        (materiales.equals("")?"":"materiales:["+materiales+"],")+
                        (maquinariasDetalles.equals("")?"":("datosMaq:["+maquinariasDetalles+"],"))+
                        "actions:{actividad:null," +
                        "Maquinaria:'ninguno'"+
                        (especificaciones.equals("")?"":",inner: ["+especificaciones+"]") +
                        "},descripcion:'"+descripcion.replace(b, '-').replace(c,' ')+"'" +
                        ",detailsOffsetY:"+(tiempoProceso>0?"5":"3")+",codProcesos:'"+codProceso+"',codSubProceso:'0'});";

                variables+=(variables.equals("")?"":",")+"s"+codProcesoProd;
                posYcen+=((cont+(descripcion.equals("")?0:6))*17)+50;
                while(resd.next())
                    {
                        cont2++;
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
                        consulta="select m.NOMBRE_MAQUINA,ISNULL(m.CODIGO,'') as cod1,isnull(eea.NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE,'') as NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE," +
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
                                 " and sppeq.COD_PROCESO_PRODUCTO=sppm.COD_PROCESO_PRODUCTO" +
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
                                         contSubproces++;
                                         espEquipSubProces+=((espEquipSubProces.equals("")?"":",")+"'"+resdd.getString("NOMBRE_ESPECIFICACION_EQUIPO_AMBIENTE")+"','"+
                                            resdd.getString("resultado")+" "+resdd.getString("unidad")+(resdd.getDouble("tolerancia")>0?(" ±"+formatoNumero.format(resdd.getDouble("tolerancia"))+" "+resdd.getString("unidad") ):"")+"'");
                                     }
                                 }
                                 maquinariasSubProces+=cabeceraSubProces.equals("")?"":((maquinariasSubProces.equals("")?"":",")+"['"+cabeceraSubProces+"',["+espEquipSubProces+"]]");
                                 cabeceraSubProces=maqSubProcess;
                                 
                        consulta="SELECT m.NOMBRE_MATERIAL,sppem.CANTIDAD ,um.ABREVIATURA"+//as cantidad,fmd.CANTIDAD,sppem.PORCIENTO_MATERIAL
                                 " FROM SUB_PROCESOS_PRODUCTO_ESP_MAT sppem inner join MATERIALES m"+
                                 " on m.COD_MATERIAL=sppem.COD_MATERIAL inner join FORMULA_MAESTRA_DETALLE_MP"+
                                 " fmd on fmd.COD_FORMULA_MAESTRA=sppem.COD_FORMULA_MAESTRA and"+
                                 " fmd.COD_MATERIAL=sppem.COD_MATERIAL"+
                                 " inner join UNIDADES_MEDIDA um on um.COD_UNIDAD_MEDIDA=fmd.COD_UNIDAD_MEDIDA"+
                                 " where  sppem.COD_SUB_PROCESO_PRODUCTO='"+codSubProcesoProd+"'"+
                                 " and sppem.COD_PROCESO_PRODUCTO='"+codProcesoProd+"'";
                         resdd=stdd.executeQuery(consulta);
                        materialesSubProceso="";
                         while(resdd.next())
                         {
                             contSubproces++;
                             materialesSubProceso+=((materialesSubProceso.equals("")?"":",")+"'"+resdd.getString("NOMBRE_MATERIAL")+"','"+
                                resdd.getString("CANTIDAD")+" ("+resdd.getString("ABREVIATURA")+")'");//nf.format(resdd.getDouble("CANTIDAD")*resdd.getDouble("PORCIENTO_MATERIAL"))
                         }
                        
                        script+="var p"+codProcesoProd+"s"+codSubProceso+"= uml.State.create({rect: {x:250, y: "+(subprocesoDer?posYder:posYizq)+", width: 400, height:"+(contSubproces+(descripcionSubProces.equals("")?0:6))*18+"},"+
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
                                ",detailsOffsetY:"+(tiempoSubProces>0?"5":"3")+",codProcesos:'"+codProceso+"',codSubProceso:'"+codSubProceso+"'});";
                        
                        variables+=(variables.equals("")?"":",")+"p"+codProcesoProd+"s"+codSubProceso;
                        posYizq+=(subprocesoDer?0:((contSubproces+(descripcionSubProces.equals("")?0:6))*18)+21);
                        posYder+=(subprocesoDer?((contSubproces+(descripcionSubProces.equals("")?0:6))*18)+21:0);
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
            System.out.println(arrow);
            scriptUnion+="var all = ["+areglo+"];";

           out.println("var nccc");
            scriptUnion+=arrow;
            System.out.println(scriptUnion);
           // System.out.println(script);
            int height=posYcen;
            height=height>posYder?height:posYder;
            height=height>posYizq?height:posYizq;
            out.println(" var paper = Joint.paper('diagrama', 1000, "+ height+");"+script+scriptUnion);
            consulta="SELECT PPD.CODIGO_DIAGRAMA FROM PROCESOS_PRODUCTO_DIAGRAMA PPD WHERE PPD.COD_COMPPROD='"+codCompProd+"'";
            System.out.println("consulta buscar diagrama registrado "+consulta);
            res=st.executeQuery(consulta);
            String codigoAnterior="";
            PreparedStatement pst=null;
            System.out.println("ccc"+height);
            String cod="var paper = Joint.paper('diagrama', 1000, "+( height+(cont2*110))+");"+script+scriptUnion;
            //out.println("var f=s153;nccc=s153.joint(s154, uml.arrow);" +
                    //"console.log(f);");
           
            if(res.next())
            {
                codigoAnterior=res.getString("CODIGO_DIAGRAMA");
                if(!codigoAnterior.equals(cod))
                {
                    consulta="update PROCESOS_PRODUCTO_DIAGRAMA set CODIGO_DIAGRAMA='"+cod.replaceAll("'","''")+"',variables='"+variables+"' where COD_COMPPROD='"+codCompProd+"'";
                    pst=con.prepareStatement(consulta);
                    if(pst.executeUpdate()>0)System.out.println("se actualizo el diagrama ");
                    pst.close();
                }
            }
            else
            {
                consulta="INSERT INTO PROCESOS_PRODUCTO_DIAGRAMA(COD_COMPPROD, CODIGO_DIAGRAMA,VARIABLES)"+
                         " VALUES ('"+codCompProd+"','"+cod.replaceAll("'","''")+"','"+variables+"')";

                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se inserto un nuevo diagrama");
                pst.close();
            }
            std.close();
            res.close();
            st.close();
            con.close();
            
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        %>


       </script>
      
    </body>
</html>
