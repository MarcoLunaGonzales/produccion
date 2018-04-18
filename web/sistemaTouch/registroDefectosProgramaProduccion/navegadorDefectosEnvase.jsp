<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="com.cofar.bean.DefectosEnvaseProgramaProduccion" %>
<%@ page import="com.cofar.bean.DefectosEnvasePersonal" %>
<%@ page import="com.cofar.bean.DefectosEnvase" %>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%> 
<f:view>

<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../reponse/css/foundation.css" />
    <link rel="STYLESHEET" type="text/css" href="../reponse/css/AtlasWeb.css" />
    
    <script>
       
          function getCodigo(codigo,cod_programa_prod,cod_com_prod,cod_lote_prod,cod_formula_maestra){
                 
                   location='../seguimiento_programa_produccion/navegador_seguimiento_programa.jsf?codigo='+codigo+'&cod_programa_prod='+cod_programa_prod+'&cod_com_prod='+cod_com_prod+'&cod_formula_maestra='+cod_formula_maestra+'&cod_lote_prod='+cod_lote_prod;
          }
          
           function redondeo2decimales(numero)
                {
                var original=parseFloat(numero);
                var result=Math.round(original*100)/100 ;
                return result;
                }
            function posNextInput(obj)
            {
                obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].focus();

            }
            /*A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error "+message+" continue con su transaccion ");
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }*/
            var tabla=null;
                function calcularTotalesTabla()
                {
                    tabla=document.getElementById("tablaDatosDefectos");
                    var sumaTotal=0;
                    if(tabla.rows[0].cells.length>2)
                    {
                        var sumaColumnas=new Array((tabla.rows[0].cells.length-2>0)?(tabla.rows[0].cells.length-2):0);
                        for(var i=0;i<sumaColumnas.length;i++)
                            {
                                sumaColumnas[i]=0;
                            }
                        for(var fila=1;fila<(tabla.rows.length-1);fila++)
                            {
                                var contCol=0;
                                var sumaDefectos=0;
                                for(var col=1;col<(tabla.rows[fila].cells.length-1);col++)
                                    {
                                        valorCelda=parseFloat(tabla.rows[fila].cells[col].getElementsByTagName('input')[0].value)
                                        sumaDefectos+=valorCelda;
                                        sumaColumnas[contCol]+=valorCelda;
                                        contCol++;
                                    }

                                    tabla.rows[fila].cells[tabla.rows[fila].cells.length-1].getElementsByTagName('span')[0].innerHTML=sumaDefectos;
                                    sumaTotal+=sumaDefectos;
                            }
                        for(var j=0;j<sumaColumnas.length;j++)
                            {
                                tabla.rows[tabla.rows.length-1].cells[j+1].getElementsByTagName('span')[0].innerHTML=sumaColumnas[j];
                            }
                        tabla.rows[tabla.rows.length-1].cells[tabla.rows[0].cells.length-1].getElementsByTagName('span')[0].innerHTML=sumaTotal;
                    }
                }
                function calcularSuma(celda)
                {
                    
                    var sumaCol=0;
                    var sumaFila=0;
                    var columna=celda.parentNode.cellIndex;
                    var filaSuma=celda.parentNode.parentNode.rowIndex;
                    var sumaTotal=0;
                    for(var col=1;col<(tabla.rows[0].cells.length-1);col++)
                        {
                            sumaFila+=parseFloat((tabla.rows[filaSuma].cells[col].getElementsByTagName('input')[0].value!='')?tabla.rows[filaSuma].cells[col].getElementsByTagName('input')[0].value:0);
                        }
                    tabla.rows[filaSuma].cells[tabla.rows[0].cells.length-1].getElementsByTagName('span')[0].innerHTML=sumaFila;
                    var ultimaCol=tabla.rows[0].cells.length-1;
                    for(var fila=1;fila<(tabla.rows.length-1);fila++)
                        {
                            sumaTotal+=parseFloat((tabla.rows[fila].cells[ultimaCol].getElementsByTagName('span')[0].innerHTML!='')?tabla.rows[fila].cells[ultimaCol].getElementsByTagName('span')[0].innerHTML:0);
                            sumaCol+=parseFloat((tabla.rows[fila].cells[columna].getElementsByTagName('input')[0].value!='')?tabla.rows[fila].cells[columna].getElementsByTagName('input')[0].value:0);
                        }
                    tabla.rows[tabla.rows.length-1].cells[columna].getElementsByTagName('span')[0].innerHTML=sumaCol;
                    tabla.rows[tabla.rows.length-1].cells[ultimaCol].getElementsByTagName('span')[0].innerHTML=sumaTotal;

                }
                function onBlurValidarNumeros(celda)
                {
                    if(celda.value.split(".").length>1)
                    {
                        alert('Solo puede introducir numeros enteros');
                        celda.focus();
                        return false;
                    }
                    if(isNaN(celda.value))
                    {
                        alert('Solo puede introducir numeros enteros');
                        celda.focus();
                        return false;

                    }
                    return true;
                }
                function valEnteros(key,celda)
                {
                    
                     var unicode=0;
                        if (key.charCode)
                        {
                            unicode=key.charCode;
                        }
                        else
                        {
                            unicode=key.keyCode;
                        }
                  if(unicode==13)
                  {
                      if(!onBlurValidarNumeros(celda))
                      {
                          alert('Solo puede introducir numeros enteros');
                      }
                      else
                      {
                          document.getElementById('buttonGuardar').click();
                          event.returnValue = false;
                      }
                  }
                  if ((unicode < 48 || unicode > 57) )
                     {
                        alert('Solo puede registrar numeros enteros');
                        event.returnValue = false;
                     }
                }
                function mas_action(){
                    last = this;
                }
                function colocaFocusUltimaFila(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   if(rowsElement.length>=2){
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel0=cellsElement[0];
                    var cel1=cellsElement[1];
                    var cel3=cellsElement[3];
                    var cel4=cellsElement[4];
                    var cel5=cellsElement[5];
                    var cel6=cellsElement[6];
                    if(cel5.getElementsByTagName('input')[0].type=='text'){
                        cel0.getElementsByTagName('input')[0].disabled = true;
                        cel1.getElementsByTagName('select')[0].disabled = true;
                        cel3.getElementsByTagName('input')[0].disabled = true;
                        cel4.getElementsByTagName('input')[0].disabled = true;
                        cel5.getElementsByTagName('input')[0].disabled = true;
                        cel5.getElementsByTagName('input')[1].disabled = true;
                        cel6.getElementsByTagName('input')[0].disabled = true;
                        cel6.getElementsByTagName('input')[1].disabled = true;



                        //document.getElementById('form1:codProducto').disabled=true;
                     }
                     break;
                   }
                   }
                }
                function focusUltimaFila(nametable){
                   var count=0;
                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   //alert(rowsElement.length);
                   if(rowsElement.length>=1){
                           for(var i=1;i<rowsElement.length;i++){
                            var cellsElement=rowsElement[i].cells;
                            //var cel0=cellsElement[0];
                            var cel1=cellsElement[1];
                                //cel0.getElementsByTagName('input')[0].disabled = true;
                                cel1.getElementsByTagName('select')[0].focus();                             
                           }
                   }
                   
                }
                function nuevoAjax()
                {	var xmlhttp=false;
                    try {
                        xmlhttp = new ActiveXObject("Msxml2.XMLHTTP");
                    } catch (e) {
                        try {
                            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                        } catch (E) {
                            xmlhttp = false;
                        }
                    }
                    if (!xmlhttp && typeof XMLHttpRequest!="undefined") {
                        xmlhttp = new XMLHttpRequest();
                    }

                    return xmlhttp;
                }
                function guardarSeguimientoDefectos()
                {

                    var tablaDefectos=document.getElementById("tablaDatosDefectos");
                    var registroDefectos=new Array();
                    var cont=0;
                    for(var i=1;i<tablaDefectos.rows.length-1;i++)
                    {
                        for(var j=1;j<tablaDefectos.rows[i].cells.length-1;j++)
                            {
                                if(parseInt(tablaDefectos.rows[i].cells[j].getElementsByTagName('input')[0].value)>0)
                                 {
                                     
                                     registroDefectos[cont]=parseInt(tablaDefectos.rows[0].cells[j].getElementsByTagName('input')[0].value);
                                     cont++;
                                     registroDefectos[cont]=parseInt(tablaDefectos.rows[i].cells[0].getElementsByTagName('input')[0].value);
                                     cont++;
                                     registroDefectos[cont]=parseInt(tablaDefectos.rows[i].cells[j].getElementsByTagName('input')[0].value);
                                     cont++;
                                 }
                            }
                    }
                    ajax=nuevoAjax();
                    document.getElementById('formsuper').style.visibility='visible';
                    document.getElementById('divImagen').style.visibility='visible';
                    ajax.open("GET","ajaxGuardarDefectosLote.jsf?codLote="+document.getElementById('codLote').value+
                        "&codComprod="+document.getElementById('codCompProd').value+
                        "&codTipoProd="+document.getElementById('codtipoPP').value+
                        "&codProgProd="+document.getElementById('codProgProd').value+
                        "&codPersonal="+document.getElementById('codPersonal').value+
                        "&codForm="+document.getElementById('codForm').value+
                        "&defectos="+registroDefectos+
                        "&a="+Math.random(),true);
                    ajax.onreadystatechange=function(){
                        if (ajax.readyState==4) {
                            if(ajax.responseText==null || ajax.responseText=='')
                            {
                                alert('No se puede conectar con el servidor, verfique su conexión a internet');
                                document.getElementById('formsuper').style.visibility='hidden';
                                document.getElementById('divImagen').style.visibility='hidden';
                                return false;
                            }
                            if(parseInt(ajax.responseText.split("\n").join(""))=='1')
                            {
                                alert('Se registraron los defectos');
                                document.getElementById('formsuper').style.visibility='hidden';
                                document.getElementById('divImagen').style.visibility='hidden';
                                returnPage();
                                return true;
                            }
                            else
                            {
                                alert("Ocurrio un error al momento de registrar los defectos "+ajax.responseText.split("\n").join(""));
                                document.getElementById('formsuper').style.visibility='hidden';
                                document.getElementById('divImagen').style.visibility='hidden';
                                return false;
                            }
                            
                        }
                    }

                    ajax.send(null);


                }
                function returnPage()
                {
                    window.location.href='navegadorPersonalAcond.jsf?codLote='+document.getElementById('codLote').value+
                        '&codTipoPP='+document.getElementById('codtipoPP').value+'&codCompProd='+document.getElementById('codCompProd').value+
                        '&codProgProd='+document.getElementById('codProgProd').value+'&codFormula='+document.getElementById('codForm').value+
                        '&cod='+Math.random();
                }
        </script>
        <style type="text/css">
            .input{
                border:none;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
            }
        </style>
</head>
<body >
    <div style="margin-top:2%;position:fixed;;width:100%;z-index:200;visibility:hidden" id="divImagen">
         <center><img src="../reponse/img/load2.gif"  style="z-index:205; "><%--margin-top:2%;position:fixed;--%>
         </center>
     </div>
            <%
             int contCeldas=0;
               String nombrePersonal=request.getParameter("nombrePersonal");
               String codPersonal=request.getParameter("codPersonal");
               String codComprod=request.getParameter("codCompProd");
               String codLoteProduccion=request.getParameter("codLote");
               String codTipoProgramaProd=request.getParameter("codTipoPP");
               String codProgramaProd=request.getParameter("codProgProd");
               String codFormula=request.getParameter("codForm");
            %>
            <input type="hidden" value="<%=codLoteProduccion%>" id="codLote">
            <input type="hidden" value="<%=codComprod%>" id="codCompProd">
            <input type="hidden" value="<%=codTipoProgramaProd%>" id="codtipoPP">
            <input type="hidden" value="<%=codPersonal%>" id="codPersonal">
            <input type="hidden" value="<%=codProgramaProd%>" id="codProgProd">
            <input type="hidden" value="<%=codFormula%>" id="codForm">
                <div style="margin:solid red 1px;margin-bottom:0px;">
                        
                                <div class="row"  style="margin-top:5px" >
                                <div class="large-12 medium-12 small-12 large-centered medium-centered small-centered columns" >

                                            <div class="row">
                                               <div class="large-12 medium-12 small-12 columns divHeaderClass" >
                                                       <label  class="inline" style="margin-bottom:auto">Datos del Lote</label>
                                                </div>
                                            </div>
                                            <div class="row" >

                                            <div  class="divContentClass large-12 medium-12 small-12 columns">
                                                    <center>
                                                   <table style="width:96%;margin-top:5px;margin-bottom:5px" cellpadding="0px" cellspacing="0px">
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
                                                               <span class="textHeaderClass">Tipo Programa</span>
                                                           </td>
                                                           <td class="tableHeaderClass" style="text-align:center">
                                                               <span class="textHeaderClass">Personal</span>
                                                           </td>

                                                       </tr>

                                                       <tr >
                                                           <%
                                                           try
                                                           {
                                                              
                                                               Connection con=null;
                                                               con=Util.openConnection(con);
                                                               Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                               String consulta="select pp.CANT_LOTE_PRODUCCION,tpp.NOMBRE_TIPO_PROGRAMA_PROD"+
                                                                               ",cp.nombre_prod_semiterminado from PROGRAMA_PRODUCCION pp inner join TIPOS_PROGRAMA_PRODUCCION tpp"+
                                                                               " on tpp.COD_TIPO_PROGRAMA_PROD=pp.COD_TIPO_PROGRAMA_PROD"+
                                                                               " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=pp.COD_COMPPROD"+
                                                                               " where pp.cod_estado_programa in (2,5,6,7) AND pp.COD_LOTE_PRODUCCION='"+codLoteProduccion+"' and pp.COD_COMPPROD='"+codComprod+"'" +
                                                                               " and pp.COD_FORMULA_MAESTRA='"+codFormula+"'"+
                                                                               " and pp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"' ";
                                                               System.out.println("consulta cabecera "+consulta);
                                                               ResultSet res=st.executeQuery(consulta);
                                                               while(res.next())
                                                               {
                                                                   %>
                                                                   <td class="tableCell" style="text-align:center">
                                                                       <span class="textHeaderClassBody"><%=codLoteProduccion%></span>
                                                                   </td>
                                                                   <td class="tableCell" style="text-align:center;">
                                                                       <span class="textHeaderClassBody"><%=res.getString("CANT_LOTE_PRODUCCION")%></span>
                                                                   </td>
                                                                   <td class="tableCell" style="text-align:center">
                                                                       <span class="textHeaderClassBody"><%=res.getString("nombre_prod_semiterminado")%></span>
                                                                   </td>
                                                                   <td class="tableCell" style="text-align:center">
                                                                       <span class="textHeaderClassBody"><%=res.getString("NOMBRE_TIPO_PROGRAMA_PROD")%></span>
                                                                   </td>
                                                                     <td class="tableCell" style="text-align:center">
                                                                       <span class="textHeaderClassBody"><%=nombrePersonal%></span>
                                                                   </td>
                                                                   <%
                                                               }
                                                          
                                                           %>
                                                           
                                                       </tr>
                                                       </table>
                                                       </center>

                                             </div>
                                             </div>
                                         </div>
                            </div>
                            

                            <div class="row">
                                 <div class="large-10 medium-11 small-12 large-centered medium-centered columns ">
                                                 <table  id="tablaDatosDefectos" style="border:none;width:100%" cellpadding="0" cellspacing="0" >
                                                        <tr class="tableHeaderClass"  >
                                                         <td style="border-top-left-radius:10px;">
                                                             <h:outputText value="Defectos" styleClass="textHeaderClass"/>
                                                        </td>
                                                         <%
                                                            consulta="select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+'<br/>'+p.AP_MATERNO_PERSONAL+'<br/>'+p.NOMBRE_PILA) as nombrePersonal"+
                                                                    " from SEGUIMIENTO_PROGRAMA_PRODUCCION_PERSONAL sppp "+
                                                                    " inner join ACTIVIDADES_FORMULA_MAESTRA afm on sppp.COD_ACTIVIDAD_PROGRAMA = afm.COD_ACTIVIDAD_FORMULA"+
                                                                    " inner join ACTIVIDADES_PRODUCCION ap on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD"+
                                                                    " and ap.COD_ACTIVIDAD in (29,40,157) inner join personal p on sppp.COD_PERSONAL=p.COD_PERSONAL"+
                                                                    " where sppp.COD_COMPPROD='"+codComprod+"'"+
                                                                    " and sppp.COD_LOTE_PRODUCCION='"+codLoteProduccion+"'"+
                                                                    " and sppp.COD_FORMULA_MAESTRA='"+codFormula+"'"+
                                                                    " and sppp.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                                                                    " and sppp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'" +
                                                                    " group by p.COD_PERSONAL,p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA" +
                                                                    " order by p.AP_PATERNO_PERSONAL,p.AP_MATERNO_PERSONAL,p.NOMBRE_PILA";
                                                        System.out.println("consulta cargar personal cabecera "+consulta);
                                                        res=st.executeQuery(consulta);
                                                        Statement stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                                                        ResultSet resDetalle=null;
                                                        List<DefectosEnvaseProgramaProduccion> defectosEnvaseLoteList=new ArrayList<DefectosEnvaseProgramaProduccion>();
                                                        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
                                                        DecimalFormat formato = (DecimalFormat)nf;
                                                        formato.applyPattern("###");
                                                        formato.setMaximumFractionDigits(0);
                                                        if(res.next())
                                                        {
                                                            contCeldas++;
                                                            %>
                                                             <td class="tableHeaderClass">
                                                                 <input type="hidden" value="<%=res.getString("COD_PERSONAL")%>">
                                                                 <span class="textHeaderClass"><%=res.getString("nombrePersonal")%></span>

                                                            </td>
                                                            <%

                                                             consulta="select de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE,ISNULL(depp.CANTIDAD_DEFECTOS_ENCONTRADOS,0) as CANTIDAD_DEFECTOS_ENCONTRADOS"+
                                                                     " from DEFECTOS_ENVASE de left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp"+
                                                                     " on de.COD_DEFECTO_ENVASE=depp.COD_DEFECTO_ENVASE "+
                                                                    " and depp.COD_COMPPROD='"+codComprod+"'"+
                                                                    " and depp.COD_LOTE_PRODUCCION='"+codLoteProduccion+"'"+
                                                                    " and depp.COD_PERSONAL='"+codPersonal+"'"+
                                                                    " and depp.COD_FORMULA_MAESTRA='"+codFormula+"'"+
                                                                    " and depp.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                                                                    " and depp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'" +
                                                                    " and depp.COD_PERSONAL_OPERARIO='"+res.getString("COD_PERSONAL")+"'"+
                                                                    " and de.cod_estado_registro=1 order by de.ORDEN";
                                                            System.out.println("consulta buscar defectos "+consulta);
                                                            resDetalle=stDetalle.executeQuery(consulta);
                                                            defectosEnvaseLoteList.clear();
                                                            while(resDetalle.next())
                                                            {
                                                                DefectosEnvaseProgramaProduccion bean=new DefectosEnvaseProgramaProduccion();
                                                                bean.getDefectoEnvase().setCodDefectoEnvase(resDetalle.getInt("COD_DEFECTO_ENVASE"));
                                                                bean.getDefectoEnvase().setNombreDefectoEnvase(resDetalle.getString("NOMBRE_DEFECTO_ENVASE"));
                                                                List<DefectosEnvasePersonal> defectosEnvasePersonalArray=new ArrayList<DefectosEnvasePersonal>();
                                                                DefectosEnvasePersonal nuevo=new DefectosEnvasePersonal();
                                                                nuevo.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                                                                nuevo.setCantidadDefectosEncontrados(resDetalle.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS"));
                                                                defectosEnvasePersonalArray.add(nuevo);
                                                                bean.setDefectosEnvasePersonalList(defectosEnvasePersonalArray);
                                                                defectosEnvaseLoteList.add(bean);
                                                            }
                                                            resDetalle.close();

                                                        }

                                                        while(res.next())
                                                        {
                                                            contCeldas++;
                                                            %>
                                                             <td class="tableHeaderClass">
                                                                 <input type="hidden" value="<%=res.getString("COD_PERSONAL")%>">
                                                                 <span class="textHeaderClass"><%=res.getString("nombrePersonal")%></span>
                                                                
                                                            </td>
                                                            <%
                                                            consulta="select de.COD_DEFECTO_ENVASE,de.NOMBRE_DEFECTO_ENVASE,ISNULL(depp.CANTIDAD_DEFECTOS_ENCONTRADOS,0) as CANTIDAD_DEFECTOS_ENCONTRADOS"+
                                                                     " from DEFECTOS_ENVASE de left outer join DEFECTOS_ENVASE_PROGRAMA_PRODUCCION depp"+
                                                                     " on de.COD_DEFECTO_ENVASE=depp.COD_DEFECTO_ENVASE "+
                                                                    " and depp.COD_COMPPROD='"+codComprod+"'"+
                                                                    " and depp.COD_LOTE_PRODUCCION='"+codLoteProduccion+"'"+
                                                                    " and depp.COD_PERSONAL='"+codPersonal+"'"+
                                                                    " and depp.COD_FORMULA_MAESTRA='"+codFormula+"'"+
                                                                    " and depp.COD_PROGRAMA_PROD='"+codProgramaProd+"'"+
                                                                    " and depp.COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'" +
                                                                    " and depp.COD_PERSONAL_OPERARIO='"+res.getString("COD_PERSONAL")+"'"+
                                                                    " and de.cod_estado_registro=1 order by de.ORDEN";
                                                            System.out.println("consulta buscar defectos "+consulta);
                                                            resDetalle=stDetalle.executeQuery(consulta);
                                                            int cont=0;
                                                            while(resDetalle.next())
                                                            {
                                                                DefectosEnvasePersonal nuevo=new DefectosEnvasePersonal();
                                                                nuevo.getPersonal().setCodPersonal(res.getString("COD_PERSONAL"));
                                                                nuevo.setCantidadDefectosEncontrados(resDetalle.getDouble("CANTIDAD_DEFECTOS_ENCONTRADOS"));
                                                                defectosEnvaseLoteList.get(cont).getDefectosEnvasePersonalList().add(nuevo);
                                                                cont++;
                                                            }
                                                            
                                                        }

                                                         %>
                                                         <td style="border-top-right-radius: 10px;">
                                                             <h:outputText value="TOTAL" styleClass="textHeaderClass" />
                                                        </td>
                                                       </tr>
                                                            <%
                                                                for(DefectosEnvaseProgramaProduccion bean:defectosEnvaseLoteList)
                                                                {

                                                                    %>
                                                                    <tr>
                                                                        <td class="" style="text-align:right;">
                                                                            <input type="hidden" value="<%=bean.getDefectoEnvase().getCodDefectoEnvase()%>">
                                                                            <span class="textHeaderClassBody"><%=bean.getDefectoEnvase().getNombreDefectoEnvase()%></span>
                                                                        </td>
                                                                    
                                                                    <%
                                                                    for(DefectosEnvasePersonal personal:bean.getDefectosEnvasePersonalList())
                                                                    {//" 
                                                                        %>
                                                                                   <td class="">
                                                                                       <input type="text" value="<%=formato.format(personal.getCantidadDefectosEncontrados())%>" size="4" onkeypress="valEnteros(event);" class="inputText" onkeyup="calcularSuma(this)" onblur="onBlurValidarNumeros(this)"/>
                                                                                         
                                                                                     </td>

                                                                        <%
                                                                    }
                                                                    %>
                                                                     <td class="">
                                                                        <span class="textHeaderClassBody" style="color:#FF0000">0.0</span>
                                                                    </td>
                                                                    </tr>
                                                                    <%
                                                                }
                                                            %>

                                                         <td class="">
                                                              <span class="textHeaderClassBody" style="color:red;"><b>TOTAL</b></span>
                                                         </td>
                                                         <%
                                                         
                                                            for(int i=0;i<contCeldas;i++)
                                                             {
                                                         %>
                                                                    <td class="" >
                                                                                <span class="textHeaderClassBody" style="color:#FF0000">0.0</span>
                                                                    </td>
                                                            <%
                                                            }
                                                            %>
                                                        
                                                          <td class="">
                                                                        <b><span class="textHeaderClassBody" style="color:#FF0000">0.0</span></b>
                                                         </td>
                                                        </tr>
                                                </table>
                                                <script>calcularTotalesTabla();</script>
                               </div>
                            </div>
                            <div class="row" style="margin-bottom:0px;">
                                        <div class="large-6 small-8 medium-10 large-centered medium-centered columns">
                                            <div class="row">
                                                <div class="large-6 medium-6 small-12 columns">
                                                    <input type="button" onclick="guardarSeguimientoDefectos();" value="Guardar" class="small button succes radius buttonAction" id="buttonGuardar">
                                                </div>
                                                    <div class="large-6 medium-6 small-12  columns">
                                                   <input type="button" onclick="returnPage();" value="Cancelar" class="small button succes radius buttonAction" id="buttonGuardar">
                                                        
                                                    </div>
                                            </div>
                                        </div>
                                    </div >
                            <%
                              }
                               catch(SQLException ex)
                               {
                                   ex.printStackTrace();
                               }


                            %>


                                      
                            
                        
                        </div>
                          <div  id="formsuper"  style="
                                padding: 50px;
                                background-color: #cccccc;
                                position:absolute;
                                z-index: 150;
                                left:0px;
                                top: 0px;
                                border :2px solid #3C8BDA;
                                width:100%;
                                height:100%;
                                filter: alpha(opacity=70);
                                visibility:hidden;
                                opacity: 0.8;" >

                          </div>
                       
</body>
</html>

</f:view>

