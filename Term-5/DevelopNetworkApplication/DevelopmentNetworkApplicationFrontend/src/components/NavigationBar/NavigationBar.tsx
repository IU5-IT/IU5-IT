import {Link} from 'react-router-dom';
import Nav from 'react-bootstrap/Nav';
import Navbar from 'react-bootstrap/Navbar';
import Form from 'react-bootstrap/Form';
import FormControl from 'react-bootstrap/FormControl';
import Button from 'react-bootstrap/Button';
import React from 'react';
import {useAppDispatch, useAppSelector} from "../../hooks/redux.ts";
import LoadAnimation from "../Popup/MyLoaderComponent.tsx";
import MyComponent from "../Popup/Popover.tsx";
import Cookies from "js-cookie";
import {userSlice} from "../../store/reducers/UserSlice.ts";
import {FormLabel} from "react-bootstrap";
import './NavigationBar.css'
import {defaultImage} from "../../models/models.ts";
import {progressSlice} from "../../store/reducers/ProgressData.ts";

const NavigationBar = () => {
    const dispatch = useAppDispatch()
    const {isLoading, success, error} = useAppSelector(state => state.userReducer)
    const userImage = Cookies.get('userImage')
    const userName = Cookies.get('userName')
    const role = Cookies.get('role')
    const jwtToken = Cookies.get('jwtToken')
    const currentUrl = window.location.pathname.split('/').pop();

    const handleSearch = (e: React.FormEvent<HTMLFormElement>) => {
        e.preventDefault();
        const inputValue = (e.currentTarget.elements.namedItem('search') as HTMLInputElement)?.value;
        dispatch(progressSlice.actions.setSearch(inputValue))
    };

    const handleLogout = () => {
        console.log('tap')
        const allCookies = Cookies.get();
        Object.keys(allCookies).forEach(cookieName => {
            Cookies.remove(cookieName);
        });
        dispatch(userSlice.actions.setAuthStatus(false))
        // dispatch(logoutSession())
    };

    return (
        <>
            {error != "" && <MyComponent isError={true} message={error}/>}
            {success != "" && <MyComponent isError={false} message={success}/>}
            <Navbar expand="sm" className="bg-black" data-bs-theme="dark">
                <div className="container-xl px-2 px-sm-3">
                    <Navbar.Toggle aria-controls="basic-navbar-nav"/>
                    <Navbar.Collapse id="basic-navbar-nav">
                        <Nav className="me-auto">
                            <Nav.Item className="mx-3">
                                <Link to="/" className="nav-link ps-0 text-info">
                                    Меню
                                </Link>
                            </Nav.Item>
                            {role == '2' &&

                                <Nav.Item>
                                    <Link to="/cities/admin" className="nav-link ps-0">
                                        Таблица городов
                                    </Link>
                                </Nav.Item>
                            }
                            <Nav.Item className="mx-3">
                                <Link to="/cities" className="nav-link ps-0">
                                    Города
                                </Link>
                            </Nav.Item>
                            <Nav.Item>
                                <Link to="/request" className="nav-link">
                                    Список заявок
                                </Link>
                            </Nav.Item>
                        </Nav>
                        {currentUrl == 'cities' &&
                            <Form onSubmit={handleSearch} className="d-flex">
                                <FormControl
                                    id={'search-text-field'}
                                    type="text"
                                    name="search"
                                    placeholder="Поиск городов"
                                    className="me-2"
                                    aria-label="Search"
                                />

                                <Button type="submit" variant="outline-light">
                                    Поиск
                                </Button>

                            </Form>
                        }
                        {jwtToken ? (
                            <>
                                <Nav>
                                    <Nav.Item className="mx-2">
                                        <Button variant="outline-light" onClick={handleLogout}>
                                            Выйти
                                        </Button>
                                    </Nav.Item>
                                </Nav>
                                <div className="avatar-container d-flex align-items-center">
                                    <Nav.Item>
                                        <img
                                            src={userImage || defaultImage}
                                            alt="User Avatar"
                                            className="avatar me-2"
                                        />
                                    </Nav.Item>
                                    <Nav.Item className="mx-2 mt-2">
                                        <FormLabel>{userName || 'Не задано'}</FormLabel>
                                    </Nav.Item>
                                </div>
                            </>
                        ) : (
                            <>
                                <Nav className="ms-2">
                                    <Nav.Item>
                                        <Link to="/login" className="btn btn-outline-light">
                                            Войти
                                        </Link>
                                    </Nav.Item>
                                </Nav>
                                <Nav className="ms-2">
                                    <Nav.Item>
                                        <Link to="/register" className="btn btn-outline-info">
                                            Регистрация
                                        </Link>
                                    </Nav.Item>
                                </Nav>
                            </>
                        )}
                    </Navbar.Collapse>
                </div>
            </Navbar>

            {isLoading && <LoadAnimation/>}
        </>
    );
};

export default NavigationBar;
