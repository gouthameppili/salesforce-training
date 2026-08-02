import { LightningElement } from 'lwc';

export default class PlacementHome extends LightningElement {

    dashboardTitle = "Placement Management Dashboard";

    welcomeMessage = "Welcome Goutham 👋";

    companyCount = 12;
    jobCount = 10;
    applicationCount = 58;

    searchJob = "";

    handleRefresh() {
        this.jobCount--;
        this.applicationCount--;
    }

    handleSearch(event) {
        this.searchJob = event.target.value;
    }

    get hasJobs() {
        return this.jobCount > 0;
    }

    jobList = [
    {
        id:1,
        name:'Salesforce Developer'
    },
    {
        id:2,
        name:'Java Developer'
    },
    {
        id:3,
        name:'Python Developer'
    },
    {
        id:4,
        name:'React Developer'
    }
];

}