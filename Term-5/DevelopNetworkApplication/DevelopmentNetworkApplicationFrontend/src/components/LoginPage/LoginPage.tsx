import {FC, useState} from 'react';
import {Container, Row, Col, Form, Button} from 'react-bootstrap';
import {useAppDispatch, useAppSelector} from "../../hooks/redux.ts";
import {loginSession} from "../../store/reducers/ActionCreator.ts";
import {useNavigate} from 'react-router-dom';

interface LoginPageProps {

}

const LoginPage: FC<LoginPageProps> = () => {
    const navigate = useNavigate();
    const dispatch = useAppDispatch()
    const {error, isAuth} = useAppSelector(state => state.userReducer)
    const [login, setLogin] = useState('');
    const [password, setPassword] = useState('');

    const handleSubmit = () => {
        if (!login || !password) {
            alert('Введите логин и пароль');
            return;
        }
        dispatch(loginSession(login, password))
    };

    if (isAuth) {
        navigate('/')
    }

    return (
        <>
            <Container>
                <label className="link-danger text-wrong-password">
                    {error}
                </label>
                <Row className="justify-content-center">
                    <Col md={5}>
                        <div className="bg-dark p-4 rounded">
                            <h2 className="text-center mb-4">Авторизация</h2>
                            <Form.Label className="font-weight-bold text-left">Логин</Form.Label>
                            <Form.Control
                                onChange={(e) => setLogin(e.target.value)}
                                type="login"
                                placeholder="Введите логин"
                                required
                            />

                            <Form.Label className="mt-3">Пароль</Form.Label>
                            <Form.Control
                                type="password"
                                placeholder="Введите пароль"
                                onChange={(e) => setPassword(e.target.value)}
                                required
                            />

                            <Button variant="primary" type="submit" className="w-100 mt-4" onClick={handleSubmit}
                                    style={{borderRadius: '10px'}}>
                                Войти
                            </Button>
                        </div>
                    </Col>
                </Row>
            </Container>
        </>
    );
};

export default LoginPage;
