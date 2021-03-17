package org.openmrs.module.patientdashboardapp.global;

import java.util.*;

/**
 * Created by Victor and francis on 10/12/2015.
 */
public class Node implements Comparable<Node> {
    private Integer id;
    private String name;
    private String date;
    private String result;
    private Set<Node> children;
    private Set<Node> results;
    private Set<String> dates;
    private Map<String,Set<Node>> mapResult;
    private Boolean isChild = false;

    public Node(Integer id, String name) {
        this.id = id;
        this.name = name;
        //ghanshyam 10-july-2013 Bug #1936 [Patient Dashboard] Wrong Result Generated in Laboratory record(note:at the place of HashSet written TreeSet)
        children = new TreeSet<Node>();
        results = new TreeSet<Node>();
    }

    public Node(String name) {
        this.name = name;
        this.results = new HashSet<Node>();;
    }

    public Node( String name, String date, String result) {
        this.name = name;
        this.isChild = true;
        this.date = date;
        this.result = result;
    }

    public Integer getId() {
        return id;
    }
    public void setId(Integer id) {
        this.id = id;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public Set<Node> getChildren() {
        return children;
    }
    public void setChildren(Set<Node> children) {
        this.children = children;
    }
    public String toString(){
        return this.name;
    }
    public String getDate() {
        return date;
    }
    public void setDate(String date) {
        this.date = date;
    }
    public String getResult() {
        return result;
    }
    public void setResult(String result) {
        this.result = result;
    }
    public Set<Node> getResults() {
        return results;
    }
    public void setResults(Set<Node> results) {
        this.results = results;
    }
    public Boolean getIsChild() {
        return isChild;
    }
    public void setIsChild(Boolean isChild) {
        this.isChild = isChild;
    }

    public int hashCode() {
        if( this.id != null && this.name != null ){
            return this.id.hashCode()  + this.name.hashCode();
        }
        else if ( this.isChild ){
            return this.result.hashCode() + this.date.hashCode();
        }
        else {
            return this.name.hashCode();
        }

    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj)
            return true;
        if (obj == null)
            return false;
        if (getClass() != obj.getClass())
            return false;
        Node node = (Node)obj;
        if( this.id != null && this.name != null && node.id != null && node.name != null ){
            return this.id.equals(node.id) && this.name.equals(node.name);
        }
        else if ( this.isChild ){
            return this.result.equals(node.result )&& this.date.equals(node.date);
        }
        else {
            return name.equals(node.name);
        }
    }


    @Override
    public int compareTo(Node o) {
        if( o == null ){
            return 1;
        }
        return this.getName().compareTo(o.getName());
    }

    public Map<String, Set<Node>> getMapResult() {
        return mapResult;
    }

    public void setMapResult(Map<String, Set<Node>> mapResult) {
        this.mapResult = mapResult;
    }

    public void addResultToMap(Node node){
        if( mapResult == null ){
            mapResult = new HashMap<String, Set<Node>>();
        }
        Set<Node> set = mapResult.get(node.getDate());
        if( set == null ){
            set = new TreeSet<Node>();
        }
        set.add(node);
        mapResult.remove(node.getDate());
        mapResult.put(node.getDate(), set);
    }

    public void addResultToSet(Node node){
        if( results == null ){
            //ghanshyam 10-july-2013 Bug #1936 [Patient Dashboard] Wrong Result Generated in Laboratory record(note:at the place of HashSet written TreeSet)
            results = new TreeSet<Node>();
        }
        results.add(node);
    }

    public Set<String> getDates() {
        return dates;
    }

    public void setDates(Set<String> dates) {
        this.dates = dates;
    }

    public void addDate(String date){
        if( dates == null ){
            dates = new TreeSet<String>();
        }
        dates.add(date);
    }

    public void addChild(Node child){
        if( children == null ){
            children = new TreeSet<Node>();
        }
        children.add(child);
    }

    public void addDates(String date){
        if( dates == null ){
            //ghanshyam 10-july-2013 Bug #1936 Feedback [Patient Dashboard] Wrong Result Generated in Laboratory record(note:at the place of TreeSet written LinkedHashSet)
            dates = new LinkedHashSet<String>();
        }
        dates.add(date);
    }
}



