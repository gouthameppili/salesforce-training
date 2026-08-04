import { LightningElement, wire } from 'lwc';
import getStudents from '@salesforce/apex/DashboardController.getStudents';
import getJobs from '@salesforce/apex/DashboardController.getJobs';
export default class PlacementHome extends LightningElement {

    students;
    jobs;
    @wire(getStudents)
    wiredStudents({ data, error }) {

        if (data) {

            this.students = data;

            console.log(data);

        } else if (error) {

            console.error(error);

        }   

    }

    @wire(getJobs)
    wiredJobs({ data, error }) {

        if (data) {

            this.jobs = data;

            console.log(data);

        } else if (error) {

            console.error(error);

        }

    }

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