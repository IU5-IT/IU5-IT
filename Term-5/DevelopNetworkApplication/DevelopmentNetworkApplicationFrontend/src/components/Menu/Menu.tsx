import {Container} from 'react-bootstrap';
import {Link, useNavigate} from 'react-router-dom';
import './Menu.css'
import {FC, useEffect} from "react";
import {useAppDispatch, useAppSelector} from "../../hooks/redux.ts";
import Cookies from "js-cookie";
import {fetchCurrentHike} from "../../store/reducers/ActionCreator.ts";

interface MenuProps {
    setPage: () => void
}

const Menu: FC<MenuProps> = ({setPage}) => {
    const dispatch = useAppDispatch()
    const {basketID} = useAppSelector(state => state.cityReducer)
    const navigate = useNavigate()
    const jwtToken = Cookies.get('jwtToken')

    useEffect(() => {
        setPage()
        dispatch(fetchCurrentHike())
    }, []);

    if (!jwtToken) {
        return <>
            <Container className="text-center mt-5">
                <div className="menu rounded p-4">
                    <h2 className="mb-2">Меню</h2>
                    <div className="d-flex flex-column">
                        <Link to="/login" className="btn btn-outline-info my-2 rounded-pill">Войти</Link>
                        <Link to="/register"
                              className="btn btn-outline-info my-2 rounded-pill">Зарегестрироваться
                        </Link>
                    </div>
                </div>
            </Container>
        </>
    }

    return (
        <Container className="text-center mt-5">
            <div className="menu rounded p-4">
                <h2 className="mb-2">Меню</h2>
                <div className="d-flex flex-column">
                    <Link to="/cities" className="btn btn-outline-info my-2 rounded-pill">Города</Link>
                    <Link to="/request" className="btn btn-outline-info my-2 rounded-pill">Список заявок</Link>
                    <Link to="/add-city" className="btn btn-outline-info my-2 rounded-pill">Создать город</Link>
                    <Link to="/cities/admin" className="btn btn-outline-info my-2 rounded-pill">Таблица городов</Link>
                    <button
                        className={`btn btn-outline-info my-2 rounded-pill ${basketID == 0 ? 'disabled' : ''}`}
                        disabled={basketID == 0}
                        onClick={() => navigate(`hikes/${basketID}`)}
                    >
                        Черновик
                    </button>
                </div>
            </div>
        </Container>
    );
};

export default Menu;
