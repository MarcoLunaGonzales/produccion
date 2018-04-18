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
                            //alert('No escogio ningun registro');
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
           function seleccionarTodoArea(){                
                for(var i=0;i<=document.getElementById("form1:codAreaEmpresa").options.length-1;i++)
                {
                    document.getElementById("form1:codAreaEmpresa").options[i].selected=document.getElementById("form1:chk_todoArea").checked;
                }
            }
            function seleccionarTodoComponente(){
                for(var i=0;i<=document.getElementById("form1:codCompProd").options.length-1;i++)
                {
                    document.getElementById("form1:codCompProd").options[i].selected=document.getElementById("form1:chk_todoComponente").checked;
                }
            }
            function deseleccionarTodo(){
                document.getElementById("form1:chk_todoArea").checked =false;
                document.getElementById("form1:chk_todoComponente").checked=false;
                /*
                for(var i=0;i<=document.getElementById("form1:codAreaEmpresa").options.length-1;i++)
                {
                    document.getElementById("form1:codAreaEmpresa").options[i].selected=document.getElementById("form1:chk_todoArea").checked;
                }
                for(var i=0;i<=document.getElementById("form1:codCompProd").options.length-1;i++)
                {
                    document.getElementById("form1:codCompProd").options[i].selected=document.getElementById("form1:chk_todoComponente").checked;
                }*/

            }

         function enviaProgramaProduccion(f){
       //sacar el valor del multiple
        /***** AREAS EMPRESA ******/



        //alert(document.getElementById('codProgramaProdPeriodo').options[document.getElementById('codProgramaProdPeriodo').selectedIndex].innerHTML);

        document.getElementById('codProgramaProduccionPeriodo').value=
            document.getElementById('form1:codProgramaProdPeriodo').options[document.getElementById('form1:codProgramaProdPeriodo').selectedIndex].value;

        if(document.getElementById('form1:codProgramaProdPeriodo').value!='-1')
            {
                document.getElementById('nombreProgramaProduccionPeriodo').value=
                    document.getElementById('form1:codProgramaProdPeriodo').options[document.getElementById('form1:codProgramaProdPeriodo').selectedIndex].innerHTML;
            } else{
                document.getElementById('nombreProgramaProduccionPeriodo').value="";
            }

           
        var arrayCompProd=new Array();
        var arrayCompProd1=new Array();
        var j=0;
        for(var i=0;i<=document.getElementById('form1:codCompProd').options.length-1;i++)
        {	if(document.getElementById('form1:codCompProd').options[i].selected)
            {	arrayCompProd[j]="'"+document.getElementById('form1:codCompProd').options[i].value+"'";
                arrayCompProd1[j]=document.getElementById('form1:codCompProd').options[i].innerHTML;
                j++;
            }
        }

        document.getElementById('codCompProdArray').value=arrayCompProd;
        document.getElementById('nombreCompProd').value=arrayCompProd1;
        
        

        
        /*******************/

        var arrayCodAreaEmpresa=new Array();
        var arrayNombreAreaEmpresa=new Array();
        j=0;
        for(var i=0;i<=document.getElementById('form1:codAreaEmpresa').options.length-1;i++)
        {	if(document.getElementById('form1:codAreaEmpresa').options[i].selected)
            {	arrayCodAreaEmpresa[j]="'"+document.getElementById('form1:codAreaEmpresa').options[i].value+"'";
                arrayNombreAreaEmpresa[j]=document.getElementById('form1:codAreaEmpresa').options[i].innerHTML;
                j++;
            }
        }


        document.getElementById('codAreaEmpresaP').value=arrayCodAreaEmpresa;
        document.getElementById('nombreAreaEmpresaP').value=arrayNombreAreaEmpresa;

        /************************/
        
        
        document.getElementById('desdeFechaP').value=document.getElementById('form1:fechaInicialInputDate').value;
        document.getElementById('hastaFechaP').value=document.getElementById('form1:fechaFinalInputDate').value;        
        document.getElementById('codEstadoProgramaProduccion').value=document.getElementById('form1:codEstadoProgramaProduccion').value;
        document.getElementById('codTipoReporteSeguimientoProgramaProduccion').value=document.getElementById('form1:codTipoReporteSeguimientoProgramaProduccion').value;

        document.getElementById('form1').action="reporteSeguimientoProgramaProduccion.jsf";
        document.getElementById('form1').submit();
        
            }
        </script>
</head>
<body>
    <h:form id="form1">
<div align="center">
    <br>
        <h:outputText value="#{ManagedReporteSeguimientoProgramaProduccion.cargarDatosReporteSeguimientoProgramaProduccion}" id="cargarDatos" styleClass="outputText2" />

    <h:panelGroup id="contenidoFiltroReporte">    
    <h:panelGrid columns="3" styleClass="panelgrid" headerClass="headerClassACliente">
        <f:facet name="header" >
             <h:outputText value="Seguimiento Programa Produccion" styleClass="outputText2" style="color:#FFFFFF"   />
        </f:facet>
        <h:outputText value="Programa Produccion ::" styleClass="outputText2" />
        <h:selectOneMenu styleClass="inputText" value="#{ManagedReporteSeguimientoProgramaProduccion.programaProduccion.codProgramaProduccion}"
         id="codProgramaProdPeriodo">
                <f:selectItems value="#{ManagedReporteSeguimientoProgramaProduccion.programaProduccionList}"/>
                <a4j:support event="onchange"  reRender="contenidoFiltroReporte" oncomplete="deseleccionarTodo()" actionListener="#{ManagedReporteSeguimientoProgramaProduccion.seleccionaProgramaProduccion_action}" />
        </h:selectOneMenu>
        <h:outputText value=" " styleClass="outputText2" />
        
        
        <h:outputText value="Area ::" styleClass="outputText2" />
        <h:selectManyListbox styleClass="inputText" value="#{ManagedReporteSeguimientoProgramaProduccion.codAreasProduccion}" size="5"
         id="codAreaEmpresa"  >
            <f:selectItems value="#{ManagedReporteSeguimientoProgramaProduccion.areaProduccionList}"/>
            <a4j:support event="onchange"  reRender="contenidoFiltroReporte" actionListener="#{ManagedReporteSeguimientoProgramaProduccion.areaProduccion_action}" />
        </h:selectManyListbox>
        <h:selectBooleanCheckbox value="#{ManagedReporteSeguimientoProgramaProduccion.checkTodoAreasProduccion}"  id="chk_todoArea">
            <a4j:support  event="onclick" actionListener="#{ManagedReporteSeguimientoProgramaProduccion.seleccionaTodosAreasProduccion_action}" reRender="contenidoFiltroReporte"/>
        </h:selectBooleanCheckbox>

        <h:outputText value="Estado Programa Produccion ::" styleClass="outputText2" />
        <h:selectOneMenu styleClass="inputText" value="#{ManagedReporteSeguimientoProgramaProduccion.codEstadoProgramaProduccion}"
         id="codEstadoProgramaProduccion">
             <f:selectItems value="#{ManagedReporteSeguimientoProgramaProduccion.estadoProgramaProduccionList}"/>
             <a4j:support event="onchange"  reRender="contenidoFiltroReporte" actionListener="#{ManagedReporteSeguimientoProgramaProduccion.estadoProgramaProduccion_action}" />
        </h:selectOneMenu>
        

        <h:outputText value=" " styleClass="outputText2" />


        <h:outputText value="Productos ::" styleClass="outputText2" />
        <h:selectManyListbox styleClass="inputText" value="#{ManagedReporteSeguimientoProgramaProduccion.codComponentesProduccion}" size="20"
        id="codCompProd">
            <f:selectItems value="#{ManagedReporteSeguimientoProgramaProduccion.componentesProduccionList}"/>            
            <a4j:support event="onchange"  reRender="chk_todoComponente" actionListener="#{ManagedReporteSeguimientoProgramaProduccion.componentesProduccion_action}"  />
        </h:selectManyListbox>
        <h:selectBooleanCheckbox value="#{ManagedReporteSeguimientoProgramaProduccion.checkTodoComponentesProduccion}" id="chk_todoComponente" onclick="seleccionarTodoComponente();">
            <a4j:support  event="onclick" actionListener="#{ManagedReporteSeguimientoProgramaProduccion.seleccionaTodosComponentesProduccion_action}" reRender="contenidoFiltroReporte"/>
        </h:selectBooleanCheckbox>

        <h:outputText value="Seguimiento ::" styleClass="outputText2" />
        <h:selectOneMenu styleClass="inputText" value="#{ManagedReporteSeguimientoProgramaProduccion.codTipoReporteSeguimiento}"
         id="codTipoReporteSeguimientoProgramaProduccion">
                <f:selectItems value="#{ManagedReporteSeguimientoProgramaProduccion.tipoReporteSeguimientoList}"/>                
        </h:selectOneMenu>
        <h:outputText value=" " styleClass="outputText2" />
        

        <h:outputText value="Fecha Inicial ::" styleClass="outputText2" />
        <rich:calendar  id="fechaInicial" datePattern="dd/MM/yyyy" styleClass="inputText"  value="#{ManagedReporteSeguimientoProgramaProduccion.fechaInicial}"  enableManualInput="false"/>
        <h:outputText value=" " styleClass="outputText2" />

        <h:outputText value="Fecha Final ::" styleClass="outputText2" />
        <rich:calendar  id="fechaFinal" datePattern="dd/MM/yyyy" styleClass="inputText"  value="#{ManagedReporteSeguimientoProgramaProduccion.fechaFinal}"  enableManualInput="false"/>
        <h:outputText value=" " styleClass="outputText2" />

     </h:panelGrid>
    </h:panelGroup>
    
    <br>
   <center>
                <input type="button" class="commandButton"  value="Ver Reporte" name="reporte" onclick="enviaProgramaProduccion(form1)">                    
                <input type="hidden" name="codigosArea" id="codigosArea">

   </center>
            <!--datos de referencia para el envio de datos via post-->
            <input type="hidden" name="codProgramaProduccionPeriodo" id="codProgramaProduccionPeriodo">
            <input type="hidden" name="nombreProgramaProduccionPeriodo"  id="nombreProgramaProduccionPeriodo">

            <input type="hidden" name="codCompProdArray" id="codCompProdArray">
            <input type="hidden" name="nombreCompProd" id="nombreCompProd">

            <input type="hidden" name="codAreaEmpresaP" id="codAreaEmpresaP">
            <input type="hidden" name="nombreAreaEmpresaP" id="nombreAreaEmpresaP">
            <input type="hidden" name="desdeFechaP" id="desdeFechaP">
            <input type="hidden" name="hastaFechaP" id="hastaFechaP">
            <input type="hidden" name="codEstadoProgramaProduccion" id="codEstadoProgramaProduccion">
            <input type="hidden" name="codTipoReporteSeguimientoProgramaProduccion" id="codTipoReporteSeguimientoProgramaProduccion">
            


</div>
<!--cerrando la conexion-->
<h:outputText value="#{ManagedActividadesFormulaMaestra.closeConnection}"  />
</h:form>


</body>
</html>

</f:view>

