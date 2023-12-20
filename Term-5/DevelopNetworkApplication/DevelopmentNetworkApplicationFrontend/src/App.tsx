import {Routes, Route} from 'react-router-dom';
import NavigationBar from "./components/NavigationBar/NavigationBar.tsx";
import CitiesList from "./components/CitiesList/CitiesList.tsx";
import CityDetail from "./components/CityDetail/CityDetail.tsx";
import {useState} from "react";
import BreadCrumbs, {Breadcrumb} from "./components/BreadCrumbs/BreadCrumbs.tsx";
import RequestView from "./components/RequestView/RequestView.tsx";
import LoginPage from "./components/LoginPage/LoginPage.tsx";
import RegisterPage from "./components/RegisterPage/RegisterPage.tsx";
import CityTable from "./components/CityTable/CityTable.tsx";
import CreateCityPage from "./components/TableView/AddCity.tsx";
import HikeCard from "./components/RequestView/HikeCard.tsx";
import Menu from "./components/Menu/Menu.tsx";

function App() {
    const homePage: Breadcrumb = {name: 'Главная', to: ''};
    const addCityPage: Breadcrumb = {name: 'Созадние города', to: 'add-city'};
    const citiesTablePage: Breadcrumb = {name: 'Таблица городов', to: 'cities/admin'};
    const citiesPage: Breadcrumb = {name: 'Города', to: 'cities'};
    const requestPage: Breadcrumb = {name: 'Заявки', to: 'request'};
    const [pages, setPage] = useState<Breadcrumb[]>([citiesPage])
    const addPage = (newPage: Breadcrumb[]) => {
        setPage(newPage);
    };

    return (
        <>
            <NavigationBar/>
            <BreadCrumbs paths={pages}/>
            <>
                <Routes>

                    <Route path="/" element={
                        <Menu
                            setPage={() => addPage([homePage])}
                        />
                    }/>

                    <Route path="/cities" element={
                        <CitiesList
                            setPage={() => addPage([homePage, citiesPage])}
                        />
                    }
                    />

                    <Route path="/request" element={
                        <RequestView
                            setPage={() => addPage([homePage, requestPage])}
                        />
                    }
                    />

                    <Route path="/add-city" element={
                        <CreateCityPage
                            setPage={() => addPage([homePage, addCityPage])}
                        />}
                    />

                    <Route path="/add-city-2" element={
                        <CreateCityPage
                            setPage={() => addPage([homePage, citiesTablePage, addCityPage])}
                        />}
                    />

                    <Route path="/login" element={<LoginPage/>}/>

                    <Route path="/cities/admin" element={
                        <CityTable
                            setPage={() => addPage([homePage, citiesTablePage])}
                        />}
                    />

                    <Route path="/register" element={<RegisterPage/>}/>

                    <Route path="/hikes/:hike_id" element={
                        <HikeCard setPage={
                            (name, id) => addPage([
                                homePage,
                                requestPage,
                                {name: `Поход: "${name}"`, to: `hike/${id}`}
                            ])
                        }/>
                    }/>

                    <Route path="/cities/:id" element={
                        <CityDetail
                            setPage={(name, id) => addPage([
                                homePage,
                                citiesPage,
                                {name: `${name}`, to: `cities/${id}`}
                            ])}
                        />}
                    />
                </Routes>
            </>
        </>
    )
}


export default App
