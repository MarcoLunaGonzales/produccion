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

                                    </script>
</head>
<body bgcolor="#F2E7F8">
<h:form id="form1"  >                
<div align="center">                    
    <br>
        <h:outputText value="#{ManagedActividadesFormulaMaestra.cargarContenidoActividadesFormulaMaestra}" styleClass="outputText2" />
    
    <h:outputText value="Procesos de Producción" styleClass="tituloCabezera1"    />
    
    <br> <br> <b></b> <h:outputText value="#{ManagedActividadesFormulaMaestra.nombreComProd}"   /></b> 
    <br>
    <br>
        Area :
        <h:selectOneMenu styleClass="inputText" value="#{ManagedActividadesFormulaMaestra.codAreaEmpresa}">
            <f:selectItems  value="#{ManagedActividadesFormulaMaestra.areasEmpresaList}" />
            <a4j:support event="onchange" action="#{ManagedActividadesFormulaMaestra.areasEmpresa_change}" reRender="dataCadenaCliente" />
        </h:selectOneMenu>
        <br /><br/>
        Presentacion :
        <h:selectOneMenu styleClass="inputText" value="#{ManagedActividadesFormulaMaestra.codPresentacion}">
            <f:selectItems  value="#{ManagedActividadesFormulaMaestra.presentacionesProductoList}" />
            <a4j:support event="onchange" action="#{ManagedActividadesFormulaMaestra.areasEmpresa_change}" reRender="dataCadenaCliente" />
        </h:selectOneMenu>
        <br /><br/>
    
    <rich:dataTable value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraList}" var="data" id="dataCadenaCliente"
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" 
                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                    headerClass="headerClassACliente"
                    columnClasses="tituloCampo"

    >
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
            <h:outputText value="#{data.ordenActividad}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Procesos de Producción"  />
            </f:facet>
            <h:outputText value="#{data.actividadesProduccion.nombreActividad}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Estado"  />
            </f:facet>
            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}"  />
        </h:column>


        
        <h:column>
            <f:facet name="header">
                <h:outputText value=" Detalle"  />
            </f:facet>
            <h:outputText value="<a  onclick=\"getCodigo('#{data.codActividadFormula}','#{data.formulaMaestra.codFormulaMaestra}','#{data.actividadesProduccion.codActividad}');\" style='cursor:hand;text-decoration:underline' ><img src='../img/organigrama3.jpg' alt='Maquinarias '></a>  "  escape="false"  />
        </h:column>   
    </rich:dataTable>
        


        <%--
    <rich:dataTable value="#{ManagedActividadesFormulaMaestra.actividadesMaquinariaFormulaMaestraList}" var="data"
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';"
                    headerClass="headerClassACliente"
                    columnClasses="tituloCampo" >
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
            <h:outputText value="#{data.actividadesFormulaMaestra.ordenActividad}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Procesos de Producción"  />
            </f:facet>
            <h:outputText value="#{data.actividadesFormulaMaestra.actividadesProduccion.nombreActividad}"  />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Horas Hombre"  />
            </f:facet>
            <h:inputText value="#{data.maquinariaActividadesFormula.horasHombre}" styleClass="inputText" size="6" />
        </h:column>
        <h:column>
            <f:facet name="header">
                <h:outputText value="Horas Maquina"  />
            </f:facet>
            <h:inputText value="#{data.maquinariaActividadesFormula.horasMaquina}" styleClass="inputText" size="6"  />
        </h:column>        
        <h:column>
            <f:facet name="header">
                <h:outputText value="Maquina"  />
            </f:facet>
            <h:selectOneMenu styleClass="inputText" value="#{data.maquinariaActividadesFormula.maquinaria.codMaquina}" id="maquinaria"  >
                <f:selectItems value="#{data.maquinariasList}"/>
            </h:selectOneMenu>
        </h:column>
    </rich:dataTable>
--%>
    <br>
   
    
    <h:commandButton value="Editar"  styleClass="commandButton"  action="#{ManagedActividadesFormulaMaestra.actionEditar}" onclick="return eliminarItem('form1:dataCadenaCliente');"/>
    <%--<h:commandButton value="Guardar"  styleClass="commandButton"  action="#{ManagedActividadesFormulaMaestra.guardarActividadesMaquinariaFormulaMaestra_action}"  />--%>
    <h:commandButton value="Registrar" styleClass="commandButton"  action="#{ManagedActividadesFormulaMaestra.Guardar}"/>
    <h:commandButton value="Eliminar"  styleClass="commandButton"  action="#{ManagedActividadesFormulaMaestra.eliminarActividadesProduccion}"  onclick="return validar('form1:dataCadenaCliente');"/>
    <h:commandButton value="Cancelar"  styleClass="commandButton"  action="navegadorFormulaMaestra"  />
    

</div>
</h:form>


</body>
</html>

</f:view>

