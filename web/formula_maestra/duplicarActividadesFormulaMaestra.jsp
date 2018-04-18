<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<f:view>
<html>
<head>
    <title>SISTEMA</title>
    <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
    <script type="text/javascript" src="../js/general.js"></script>
    <script>
        function validarRegistro()
        {
            var tabla=document.getElementById('form1:dataActividades');
            for(var i=1;i<tabla.rows.length;i++)
                {
                    if(tabla.rows[i].cells[0].getElementsByTagName('input')[0].checked==true)
                        {
                            if((tabla.rows[i].cells[1].getElementsByTagName('input')[0].value==''?0:
                            parseInt(tabla.rows[i].cells[1].getElementsByTagName('input')[0].value))<1)
                            {
                                alert('debe asignar un numero de orden valido para la actividad '+
                                    tabla.rows[i].cells[2].getElementsByTagName('span')[0].innerHTML);
                                return false;
                            }
                        }
                }
                return true;
        }
        function actionGuardar()
        {
            document.getElementById('form1:buttonGuardar').style.visibility='hidden';
            document.getElementById('buttonCancelar').style.visibility='hidden';
            document.getElementById('form1:progress').style.visibility='visible';
            
        }

         
    </script>
</head>
<body>

<h:form id="form1">

<div align="center">
    <br>
        <h:outputText value="#{ManagedActividadesFormulaMaestra.cargarDuplicarActividades}"/>
    <rich:panel headerClass="headerClassACliente" style="align:center;text-align:center;width:60%;margin-top:10px;">
        <f:facet name="header">
            <h:outputText value="Datos del Producto de referencia"/>
        </f:facet>
        <rich:panel headerClass="headerClassACliente" style="align:center;text-align:center;margin-top:10px;">
                <f:facet name="header">
                    <h:outputText value="Duplicar desde:"/>
                </f:facet>
                <h:panelGrid columns="3">
                <h:outputText value="Producto" styleClass="outputText2" style="font-weight:bold"/>
                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.formulaMaestra.codFormulaMaestra}" styleClass="inputText" >
                    <f:selectItems value="#{ManagedActividadesFormulaMaestra.formulaMaestraSelectList}"/>
                    <a4j:support action="#{ManagedActividadesFormulaMaestra.codFormulaMaestra_change}" reRender="codPresentacion" event="onchange"/>
                </h:selectOneMenu>
                <h:outputText value="Presentacion" styleClass="outputText2" style="font-weight:bold"/>
                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                <h:selectOneMenu id="codPresentacion" value="#{ManagedActividadesFormulaMaestra.codPresentacionDuplicar}" styleClass="inputText">
                    <f:selectItem itemLabel="--TODOS--" itemValue="0"/>
                    <f:selectItems value="#{ManagedActividadesFormulaMaestra.presentacionesSelectList}"/>
                </h:selectOneMenu>
                <h:outputText value="Area Actividad" styleClass="outputText2" style="font-weight:bold"/>
                <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                <h:selectOneMenu value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicar.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                    <f:selectItem itemValue="0" itemLabel="--TODOS--"/>
                    <f:selectItems value="#{ManagedActividadesFormulaMaestra.areasEmpresaActividadSelectList}"/>
                </h:selectOneMenu>
            </h:panelGrid>
        </rich:panel>
        <rich:panel headerClass="headerClassACliente" style="align:center;text-align:center;margin-top:10px;">
                <f:facet name="header">
                    <h:outputText value="A Producto:"/>
                </f:facet>
                <h:panelGrid columns="3">
                    <h:outputText value="Duplicar Datos en " styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                    <h:selectOneMenu  value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDestino.formulaMaestra.codFormulaMaestra}" styleClass="inputText">
                        <f:selectItems value="#{ManagedActividadesFormulaMaestra.formulaMaestraSelectList}"/>
                        <a4j:support action="#{ManagedActividadesFormulaMaestra.codFormulaMaestraDestino_change}" reRender="codPresentacionDestino" event="onchange"/>
                    </h:selectOneMenu>
                    <h:outputText value="Presentacion" styleClass="outputText2" style="font-weight:bold"/>
                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                    <h:selectOneMenu id="codPresentacionDestino" value="#{ManagedActividadesFormulaMaestra.codPresentacionDestino}" styleClass="inputText">
                        <f:selectItem itemLabel="--TODOS--" itemValue="0"/>
                        <f:selectItems value="#{ManagedActividadesFormulaMaestra.presentacionesDestinoSelectList}"/>
                    </h:selectOneMenu>
                </h:panelGrid>
        </rich:panel>
        <a4j:commandButton value="BUSCAR" action="#{ManagedActividadesFormulaMaestra.buscarActidadesDatosFiltro_action}" styleClass="btn" reRender="dataActividades"/>
    </rich:panel>
    <rich:dataTable value="#{ManagedActividadesFormulaMaestra.actividadesFormulaMaestraDuplicarList}" var="data" id="dataActividades"
                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';" style="margin-top:12px;"
                    onRowMouseOver="this.style.backgroundColor='#CCDFFA';" 
                    headerClass="headerClassACliente"
                    columnClasses="tituloCampo">
        <f:facet name="header">
                <rich:columnGroup>
                    <rich:column rowspan="2">
                        <h:outputText value=""  />
                    </rich:column >
                    <rich:column rowspan="2">
                        <h:outputText value="Area"  style="font-weight:bold" />
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value="Orden" style="font-weight:bold" />
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value="Actividad Producción"  style="font-weight:bold"/>
                    </rich:column>
                    <rich:column rowspan="2">
                        <h:outputText value="Estado"  style="font-weight:bold"/>
                    </rich:column>
                    <rich:column colspan="5" >
                        <h:outputText value="Detalle Maquinarias"  style="font-weight:bold"/>
                    </rich:column>
                    <rich:column breakBefore="true">
                        <h:outputText value=""  />
                    </rich:column>
                    <rich:column>
                        <h:outputText value="Maquinaria"  style="font-weight:bold" />
                    </rich:column>
                    <rich:column>
                        <h:outputText value="Horas Maquina" style="font-weight:bold" />
                    </rich:column>
                    <rich:column>
                        <h:outputText value="Horas Hombre" style="font-weight:bold" />
                    </rich:column>
                    <rich:column>
                        <h:outputText value="Estado"  style="font-weight:bold" />
                    </rich:column>

                </rich:columnGroup>
        </f:facet>
               
                <rich:subTable value="#{data.maquinariaActividadesFormulaList}" var="subData" rowKeyVar="rowkey">
                         <rich:column rowspan="#{data.cantidadMaquinarias}" rendered="#{rowkey eq 0}">
                            <h:selectBooleanCheckbox value="#{data.checked}"  />
                        </rich:column>
                        <rich:column rowspan="#{data.cantidadMaquinarias}" rendered="#{rowkey eq 0}">
                            <h:outputText value="#{data.formulaMaestra.componentesProd.areasEmpresa.nombreAreaEmpresa}"  />
                        </rich:column>
                        <rich:column rowspan="#{data.cantidadMaquinarias}" rendered="#{rowkey eq 0}">
                            <h:inputText value="#{data.ordenActividad}" styleClass="inputText" onkeypress="valNum();" size="4"/>
                        </rich:column>
                        <rich:column rowspan="#{data.cantidadMaquinarias}" rendered="#{rowkey eq 0}">
                            <h:outputText value="#{data.actividadesProduccion.nombreActividad}" styleClass="outputText2" />
                        </rich:column>
                        <rich:column rowspan="#{data.cantidadMaquinarias}" rendered="#{rowkey eq 0}">
                            <h:outputText value="#{data.estadoReferencial.nombreEstadoRegistro}" styleClass="outputText2" />
                        </rich:column>
                        <rich:column>
                            <h:selectBooleanCheckbox value="#{subData.checked}" rendered="#{subData.maquinaria.codMaquina != '0'}" />
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{subData.maquinaria.nombreAreaMaquina}" styleClass="outputText2" />
                        </rich:column>
                        <rich:column>
                            <h:inputText value="#{subData.horasMaquina}" styleClass="inputText" onkeypress="valNum();" size="4" rendered="#{subData.maquinaria.codMaquina !='0'}"/>
                        </rich:column>
                        <rich:column>
                            <h:inputText value="#{subData.horasHombre}" styleClass="inputText" onkeypress="valNum();" size="4" rendered="#{subData.maquinaria.codMaquina !='0'}"/>
                        </rich:column>
                        <rich:column>
                            <h:outputText value="#{subData.estadoReferencial.nombreEstadoRegistro}" styleClass="outputText2" />
                        </rich:column>
                </rich:subTable>
    </rich:dataTable>
    
    <br>
        <a4j:commandButton value="Guardar" id="buttonGuardar" styleClass="btn" action="#{ManagedActividadesFormulaMaestra.replicarDatosActividadesFormula}"
        oncomplete="if(#{ManagedActividadesFormulaMaestra.mensaje eq '1'}){alert('Se realizo la duplicacion de datos correctamente');window.location.href='navegadorFormulaMaestraActividad.jsf?cancel='+(new Date()).getTime().toString();}
        else{alert('#{ManagedActividadesFormulaMaestra.mensaje}');}"/>
         <input type="button" value="Cancelar" id="buttonCancelar"  Class="btn" onclick="window.location.href='navegadorFormulaMaestraActividad.jsf?cancel='+(new Date()).getTime().toString();" />
      <h:panelGrid>
            <h:graphicImage url="../img/load.gif" id="progress" style="visibility:hidden"/>
      </h:panelGrid>
</div>

</h:form>
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
</body>
</html>

</f:view>

