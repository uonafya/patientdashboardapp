package org.openmrs.module.patientdashboardui.page.controller;

import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.LabService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.Lab;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.openmrs.module.patientdashboardui.gobal.Node;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestParam;


import java.util.*;

/**
 * Created by VICTOR AND FRANCIS on 10/12/2015.
 */
public class InvestigationReportPageController {
    public void get(@RequestParam("patientId") Integer patientId,@RequestParam(value="date", required=false) String date, PageModel model){
        PatientDashboardService dashboardService =  Context.getService(PatientDashboardService.class);
        String orderLocationId = "1";
        Location location = StringUtils.hasText(orderLocationId) ? Context.getLocationService().getLocation(Integer.parseInt(orderLocationId)) : null;
        LabService labService = Context.getService(LabService.class);

        // get all labs
        List<Lab> labs = labService.getAllActivelab();

        // get all test in system base on list labs
        Set<Concept> listParent = new HashSet<Concept>();
        if ( labs != null && !labs.isEmpty() ){
            for( Lab lab : labs ){
                listParent.addAll(lab.getInvestigationsToDisplay());
            }
        }
        Set<Node> nodes = new TreeSet<Node>();
        Patient patient = Context.getPatientService().getPatient(patientId);
        String gpLabEncType = Context.getAdministrationService().getGlobalProperty(PatientDashboardConstants.PROPERTY_LAB_ENCOUTNER_TYPE);
        EncounterType labEncType = Context.getEncounterService().getEncounterType(gpLabEncType);
        List<Encounter> encounters = dashboardService.getEncounter(patient, location, labEncType, date);

        Set<String> dates = new LinkedHashSet<String>();

        if( encounters != null && encounters.size() > 0 )
        {
            Set<Obs> listObs = null;
            Concept obsConcept  = null;
            Concept orderConcept  = null;

            for( Encounter enc : encounters)
            {
                listObs = enc.getAllObs(false);
                if( listObs != null && !listObs.isEmpty() ){
                    for( Obs obs : listObs ){
                        // result
                        obsConcept = obs.getConcept();
                        orderConcept = obs.getOrder().getConcept();

                        if( orderConcept.getConceptClass().getName().equalsIgnoreCase("Test")){
                            Node node = new Node(obsConcept.getConceptId(), obsConcept.getName().toString());
                            addNode(node, nodes, obsConcept, listParent);
                        }else if( orderConcept.getConceptClass().getName().equalsIgnoreCase("Labset")){
                            Node node = new Node(obsConcept.getConceptId(), obsConcept.getName().toString());
                            nodes = addNodeAndChild(nodes, orderConcept, node, null, listParent, false);

                        }
                        // add date
                        dates.add(Context.getDateFormat().format(obs.getDateCreated()));
                    }
                }

            }

        }
    }
    private Node  addNode(Node node, Set<Node>  nodes , Concept concept, Set<Concept> listParent) {

        for( Concept pa : listParent ){
            for(  ConceptAnswer answer : pa.getAnswers()){
                if( answer.getAnswerConcept().getId().equals(concept.getConceptId())){
                    Node parentNode =  getNode(pa.getConceptId(), nodes);
                    if( parentNode == null ){
                        parentNode = new Node(pa.getConceptId(), pa.getName().toString());
                        nodes.add(parentNode);
                    }

                    // add orderNode to parent
                    parentNode.addChild(node);
                }
            }

            //find parent of order concept : Labset  case
            List<Concept> set = Context.getConceptService().getConceptsByConceptSet(pa);
            if( set != null && set.size() > 0){
                if ( set.contains(concept)){
                    Node parentNode =  getNode(pa.getConceptId(), nodes);
                    if( parentNode == null ){
                        parentNode = new Node(pa.getConceptId(), pa.getName().toString());
                        nodes.add(parentNode);
                    }
                    // add orderNode to parent
                    parentNode.addChild(node);
                }
            }
        }
        return node;
    }

    private Set<Node>  addNodeAndChild(Set<Node>  nodes , Concept pa, Node childNode, Node resultNode, Set<Concept> listParent, boolean result) {
        Node paNode = getNode(pa.getConceptId(), nodes);
        if( paNode == null ){
            Node node = new Node(pa.getConceptId(), pa.getName().toString());
            paNode =  addNode(node, nodes, pa, listParent);
        }
        if( ! result ){
            paNode.getChildren().add(childNode);
        }else {
            paNode.addDates(resultNode.getDate());
            paNode.getChildren().add(childNode);
            paNode.addResultToMap(resultNode);
        }
        return nodes;
    }

    private Node getNode(Integer id, Set<Node> nodes ){
        for( Node n : nodes ){
            if( n.getId().equals(id)){
                return n;
            }else {
                Node rs = getNode(id, n.getChildren());
                if( rs != null ) return rs;
            }
        }
        return null;
    }
}


