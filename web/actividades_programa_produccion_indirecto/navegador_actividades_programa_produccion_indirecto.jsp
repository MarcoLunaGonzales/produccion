
<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>


<f:view>

<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <script type="text/javascript" src='../js/general.js' ></script>
    <script type="text/javascript" src='../js/treeComponet.js' ></script> 
    <script>
         function getCodigo(codigo,cod_formula,cod_actividad){
                 //  alert(codigo);
                   location='../maquinaria_actividades_formula/navegador_maq_actividades_formula.jsf?codigo='+codigo+'&cod_formula='+cod_formula+'&cod_actividad='+cod_actividad;
                }
          function eliminar(nametable){
               var count1=0;
               var elements1=document.getElementById(nametable);
               var rowsElement1=elements1.rows;
               //alert(rowsElement1.length);            
               for(var i=1;i<rowsElement1.length;i++){
                    var cellsElement1=rowsElement1[i].cells;
                    var cel1=cellsElement1[0];
                    if(cel1.getElementsByTagName('input').length>0){
                        if(cel1.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel1.getElementsByTagName('input')[0].checked){
                               count1++;
                           }
                        }
                    }
                    
               }
               //alert(count1);
               if(count1==0){
                    alert('No escogio ningun registro');
                    return false;
               }else{
                
                
                    if(confirm('Desea Eliminar el Registro')){
                        if(confirm('Esta seguro de Eliminar el Registro')){
                            var count=0;
                            var elements=document.getElementById(nametable);
                            var rowsElement=elements.rows;
                            
                            for(var i=0;i<rowsElement.length;i++){
                                var cellsElement=rowsElement[i].cells;
                                var cel=cellsElement[0];
                                if(cel.getElementsByTagName('input').length>0){
                                    if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                                        if(cel.getElementsByTagName('input')[0].checked){
                                            count++;
                                        }
                                    }
                                }

                            }
                            if(count==0){
                            alert('No escogio ningun registro');
                            return false;
                            }
                            //var cantidadeliminar=document.getElementById('form1:cantidadeliminar');
                            //cantidadeliminar.value=count;
                            return true;
                        }else{
                            return false;
                        }
                    }else{
                        return false;
                    }
                }
           }
           function validar(nametable){

                    var count=0;
                    var elements=document.getElementById(nametable);
                    var rowsElement=elements.rows;
                    for(var i=1;i<rowsElement.length;i++){
                        var cellsElement=rowsElement[i].cells;
                        var cel=cellsElement[0];
                        if(cel.getElementsByTagName('input')[0].type=='checkbox'){
                            if(cel.getElementsByTagName('input')[0].checked){
                                count++;
                            }
                        }
                    }
                    if(count==0){
                        alert('No selecciono ningun Registro');
                        return false;
                    }else{
                     if(count>1){
                        alert('solo se puede editar un Registro');
                        return false;
                    }
                    }
                    return true;
                }
            A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error "+message+" continue con su transaccion ");
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
<body bgcolor="#F2E7F8">
<a4j:form id="form1"  >                
<div align="center">                    
    <br>
        <h:outputText value="#{ManagedActividadesProgramaProduccionIndirecto.cargarContenidoActividadesProgramaProduccionIndirecto}" styleClass="outputText2" />
    
    <rich:panel headerClass="headerClassACliente" style="width:70%">
        <f:facet name="header">
            <h:outputText value="Actividades Indirectas de producción"/>
        </f:facet>
        <h:outputText value="Area Actividad" styleClass="outputTextBold"/>
        <h:outputText value="::" styleClass="outputTextBold"/>
        <h:selectOneMenu styleClass="inputText" value="#{ManagedActividadesProgramaProduccionIndirecto.codAreaEmpresa}">
            <f:selectItems  value="#{ManagedActividadesProgramaProduccionIndirecto.areasEmpresaActividadSelectList}" />
            <a4j:support event="onchange" action="#{ManagedActividadesProgramaProduccionIndirecto.areasEmpresa_change}" reRender="dataCadenaCliente" />
        </h:selectOneMenu>
    </rich:panel>
    
    <rich:dataTable value="#{ManagedActividadesProgramaProduccionIndirecto.actividadesProgramaProduccionIndirectoList}" var="data" id="dataCadenaCliente"
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                    headerClass="headerClassACliente"
                    style="margin-top:1em"
                    columnClasses="tituloCampo">
        <h:column>
            <f:facet name="header">
                <h:outputText value=""  />
                
            </f:facet>
            <h:selectBooleanCheckbox value="#{data.checked}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Orden"  />
            </f:facet>
            <h:outputText value="#{data.orden}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Procesos de Producción"  />
            </f:facet>
            <h:outputText value="#{data.actividadesProduccion.nombreActividad}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Horas Hombre"  />
            </f:facet>
            <h:outputText value="#{data.horasHombre}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Estado"  />
            </f:facet>
            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
        </h:column>


        
           
    </rich:dataTable>
        

    <br>
   
    <a4j:commandButton value="Agregar" styleClass="btn" onclick="window.location.href='agregar_actividades_programa_produccion_indirecto.jsf?agreg='+(new Date()).getTime().toString();" />
    <a4j:commandButton value="Editar"  styleClass="btn"  action="#{ManagedActividadesProgramaProduccionIndirecto.actionEditar}" onclick="if(!eliminarItem('form1:dataCadenaCliente')){return false;}"
                       oncomplete="window.location.href='modificar_actividades_programa_produccion_indirecto.jsf?date='+(new Date()).getTime().toString();"/>
    <a4j:commandButton value="Eliminar"  styleClass="btn"  action="#{ManagedActividadesProgramaProduccionIndirecto.eliminarRegistroAction}"
                       oncomplete="if(#{ManagedActividadesProgramaProduccionIndirecto.mensaje eq '1'}){alert('Se elimino la actividad')}else{alert('#{ManagedActividadesProgramaProduccionIndirecto.mensaje}');}" reRender="dataCadenaCliente" />
    
    

</div>
</a4j:form>
<a4j:status id="statusPeticion"
            onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
            onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
</a4j:status>

<rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                 minWidth="200" height="80" width="400" zindex="300" onshow="window.focus();">

    <div align="center">
        <h:graphicImage value="../img/load2.gif" />
    </div>
</rich:modalPanel>

</body>
</html>

</f:view>

