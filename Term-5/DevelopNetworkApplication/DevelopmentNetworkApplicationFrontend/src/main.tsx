import ReactDOM from 'react-dom/client'
import {BrowserRouter} from 'react-router-dom'
import './assets/styles/global.css'
import App from './App';
import {Provider} from "react-redux";
import {setupStore} from "./store/store.ts";

const store = setupStore();

ReactDOM.createRoot(document.getElementById('root')!).render(
    <Provider store={store}>
        <BrowserRouter basename={`${import.meta.env.BASE_URL}`}>
            <App/>
        </BrowserRouter>
    </Provider>
);
