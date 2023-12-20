import {FC, useState} from 'react';
import {Container, Row, Col, Form, Button} from 'react-bootstrap';
import {registerSession} from '../../store/reducers/ActionCreator.ts';
import {useAppDispatch, useAppSelector} from "../../hooks/redux.ts";
import {Link} from "react-router-dom";

interface RegisterPageProps {
}

const RegisterPage: FC<RegisterPageProps> = () => {
    const dispatch = useAppDispatch();
    const [username, setUsername] = useState('');
    const [login, setLogin] = useState('');
    const [password, setPassword] = useState('');
    const [confirmPassword, setConfirmPassword] = useState('');
    const {success, isAuth} = useAppSelector(state => state.userReducer)

    const handleRegister = () => {
        if (!username || !login || !password || !confirmPassword) {
            alert('Пожалуйста, заполните все поля');
            return;
        }

        if (password !== confirmPassword) {
            alert('Пароли не совпадают');
            return;
        }

        dispatch(registerSession(username, login, password))
    };

    if (success != '') {
        return <Link to="/login" className="btn btn-outline-danger">
            Войдите в систему
        </Link>
    }


    if (isAuth) {
        return <Link to="/cities" className="btn btn-outline-danger">
            Смотреть города
        </Link>
    }

    return (
        <>
            <Container>
                <Row className="justify-content-center">
                    <Col md={5}>
                        <div className="bg-dark p-4 rounded">
                            <h2 className="text-center mb-4">Регистрация</h2>
                            <Form.Label className="font-weight-bold text-left">Имя пользователя</Form.Label>
                            <Form.Control
                                onChange={(e) => setUsername(e.target.value)}
                                type="text"
                                placeholder="Введите имя пользователя"
                                required
                            />

                            <Form.Label className="mt-3">Логин</Form.Label>
                            <Form.Control
                                onChange={(e) => setLogin(e.target.value)}
                                type="text"
                                placeholder="Введите логин"
                                required
                            />

                            <Form.Label className="mt-3">Пароль</Form.Label>
                            <Form.Control
                                onChange={(e) => setPassword(e.target.value)}
                                type="password"
                                placeholder="Введите пароль"
                                required
                            />

                            <Form.Label className="mt-3">Подтвердите пароль</Form.Label>
                            <Form.Control
                                onChange={(e) => setConfirmPassword(e.target.value)}
                                type="password"
                                placeholder="Подтвердите пароль"
                                required
                            />

                            <Button
                                variant="primary"
                                type="submit"
                                className="w-100 mt-4"
                                onClick={handleRegister}
                                style={{borderRadius: '10px'}}
                            >
                                Зарегистрироваться
                            </Button>
                        </div>
                    </Col>
                </Row>
            </Container>
        </>
    );
};

export default RegisterPage;
